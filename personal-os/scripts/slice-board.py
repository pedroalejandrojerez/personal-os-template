#!/usr/bin/env python3
"""Update a Build Slice Board without hand-editing the Kanban section."""

from __future__ import annotations

import argparse
import datetime as dt
import fcntl
import html
import os
import re
import subprocess
import sys
from pathlib import Path


COLUMNS = ("Ready", "In Progress", "Blocked", "Review", "Done")
STATUS_BY_ACTION = {
    "claim": "In Progress",
    "block": "Blocked",
    "review": "Review",
    "done": "Done",
}


def git_root() -> Path:
    output = subprocess.check_output(
        ["git", "rev-parse", "--show-toplevel"],
        text=True,
        stderr=subprocess.DEVNULL,
    ).strip()
    return Path(output)


def default_root() -> Path:
    if os.environ.get("SLICE_BOARD_ROOT"):
        return Path(os.environ["SLICE_BOARD_ROOT"]).expanduser()
    if os.environ.get("CONDUCTOR_ROOT_PATH"):
        return Path(os.environ["CONDUCTOR_ROOT_PATH"]).expanduser()
    return git_root()


def board_path(feature: str, explicit: str | None) -> Path:
    if explicit:
        return Path(explicit).expanduser()
    return default_root() / ".context" / "builds" / feature / "slices.md"


def lock_path(path: Path) -> Path:
    return path.with_suffix(path.suffix + ".lock")


def read_board(path: Path) -> str:
    if not path.exists():
        raise SystemExit(f"Board not found: {path}")
    return path.read_text()


def write_board(path: Path, text: str) -> None:
    path.write_text(text)


def parse_index_titles(text: str) -> dict[str, str]:
    titles: dict[str, str] = {}
    for line in text.splitlines():
        if not line.startswith("|"):
            continue
        parts = [part.strip() for part in line.strip().strip("|").split("|")]
        if len(parts) < 2 or parts[0] in {"ID", "----"}:
            continue
        if re.fullmatch(r"\d{2,4}", parts[0]):
            titles[parts[0]] = parts[1] or "untitled"
    return titles


def parse_current_cards(text: str) -> dict[str, list[str]]:
    cards = {column: [] for column in COLUMNS}
    section = section_between(text, "## Kanban Board", "## Slice Index")
    current: str | None = None
    for line in section.splitlines():
        heading = re.match(r"^###\s+(.+?)\s*$", line)
        if heading and heading.group(1) in cards:
            current = heading.group(1)
            continue
        if current and line.startswith("- ["):
            cards[current].append(line)
    return cards


def section_between(text: str, start_marker: str, end_marker: str) -> str:
    start = text.find(start_marker)
    if start == -1:
        raise SystemExit(f"Missing section: {start_marker}")
    end = text.find(end_marker, start)
    if end == -1:
        raise SystemExit(f"Missing section: {end_marker}")
    return text[start:end]


def card_id(line: str) -> str | None:
    match = re.search(r"\b(\d{2,4})\b", line)
    return match.group(1) if match else None


def card_line(slice_id: str, title: str, status: str, workspace: str, note: str) -> str:
    checked = "x" if status == "Done" else " "
    suffix = ""
    if status == "In Progress" and workspace:
        suffix = f" ({workspace})"
    if status == "Blocked" and note:
        suffix = f" (Blocked: {note})"
    if status == "Review" and note:
        suffix = f" (Review: {note})"
    if status == "Done" and note:
        suffix = f" ({note})"
    return f"- [{checked}] {slice_id} - {title}{suffix}"


def parse_index_rows(text: str) -> list[dict[str, str]]:
    rows: list[dict[str, str]] = []
    for line in text.splitlines():
        if not line.startswith("|"):
            continue
        parts = [part.strip() for part in line.strip().strip("|").split("|")]
        if len(parts) < 7 or not re.fullmatch(r"\d{2,4}", parts[0]):
            continue
        rows.append(
            {
                "id": parts[0],
                "slice": parts[1],
                "blocks": parts[2],
                "type": parts[3],
                "workspace": parts[4],
                "status": parts[5],
                "verification": parts[6],
            }
        )
    return rows


def parse_event_log(text: str) -> list[str]:
    marker = "\n## Event Log\n"
    if marker not in text:
        return []
    section = text.split(marker, 1)[1]
    next_heading = section.find("\n## ")
    if next_heading != -1:
        section = section[:next_heading]
    return [line[2:].strip() for line in section.splitlines() if line.startswith("- ")]


def html_path_for_board(path: Path) -> Path:
    return path.with_suffix(".html")


def clean_card_label(line: str) -> str:
    return re.sub(r"^-\s+\[[ x]\]\s+", "", line).strip()


def status_class(status: str) -> str:
    return re.sub(r"[^a-z0-9]+", "-", status.lower()).strip("-") or "unknown"


def render_html(path: Path, output_path: Path | None = None) -> Path:
    text = read_board(path)
    cards = parse_current_cards(text)
    rows = parse_index_rows(text)
    events = parse_event_log(text)
    output = output_path or html_path_for_board(path)
    generated = dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    title = "Slice Board"
    first_line = text.splitlines()[0].strip() if text.splitlines() else ""
    if first_line.startswith("# "):
        title = first_line[2:].strip()

    counts = {column: len(cards[column]) for column in COLUMNS}
    total = sum(counts.values())

    column_html = []
    for column in COLUMNS:
        card_html = []
        for line in cards[column]:
            label = clean_card_label(line)
            sid = card_id(line) or ""
            row = next((item for item in rows if item["id"] == sid), {})
            meta = []
            if row.get("type"):
                meta.append(row["type"])
            if row.get("workspace"):
                meta.append(row["workspace"])
            if row.get("verification"):
                meta.append(row["verification"])
            card_html.append(
                "<article class=\"card\">"
                f"<div class=\"card-title\">{html.escape(label)}</div>"
                f"<div class=\"card-meta\">{html.escape(' | '.join(meta))}</div>"
                "</article>"
            )
        empty = "<p class=\"empty\">No slices</p>" if not card_html else ""
        column_html.append(
            "<section class=\"column\">"
            f"<header><h2>{html.escape(column)}</h2><span>{counts[column]}</span></header>"
            + "".join(card_html)
            + empty
            + "</section>"
        )

    row_html = []
    for row in rows:
        css = status_class(row["status"])
        row_html.append(
            "<tr>"
            f"<td>{html.escape(row['id'])}</td>"
            f"<td>{html.escape(row['slice'])}</td>"
            f"<td>{html.escape(row['blocks'])}</td>"
            f"<td>{html.escape(row['type'])}</td>"
            f"<td>{html.escape(row['workspace'])}</td>"
            f"<td><span class=\"badge {css}\">{html.escape(row['status'])}</span></td>"
            f"<td>{html.escape(row['verification'])}</td>"
            "</tr>"
        )

    event_html = [
        f"<li>{html.escape(event)}</li>" for event in events[-12:]
    ] or ["<li>No events yet</li>"]

    document = f"""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta http-equiv="refresh" content="15">
  <title>{html.escape(title)}</title>
  <style>
    :root {{
      --bg: #f6f7f9;
      --panel: #ffffff;
      --ink: #181b20;
      --muted: #68707d;
      --line: #d9dde4;
      --ready: #5b6573;
      --progress: #2364aa;
      --blocked: #b42318;
      --review: #8a5a00;
      --done: #247a4d;
    }}
    * {{ box-sizing: border-box; }}
    body {{
      margin: 0;
      background: var(--bg);
      color: var(--ink);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
      line-height: 1.4;
    }}
    main {{ padding: 24px; }}
    .top {{
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
      gap: 16px;
      margin-bottom: 20px;
    }}
    h1 {{ margin: 0; font-size: 28px; font-weight: 700; letter-spacing: 0; }}
    .sub {{ margin-top: 6px; color: var(--muted); font-size: 14px; }}
    .stats {{ display: flex; gap: 8px; flex-wrap: wrap; justify-content: flex-end; }}
    .stat {{
      border: 1px solid var(--line);
      background: var(--panel);
      border-radius: 8px;
      padding: 8px 10px;
      min-width: 78px;
      text-align: right;
    }}
    .stat strong {{ display: block; font-size: 20px; }}
    .stat span {{ color: var(--muted); font-size: 12px; }}
    .board {{
      display: grid;
      grid-template-columns: repeat(5, minmax(180px, 1fr));
      gap: 12px;
      align-items: start;
      overflow-x: auto;
      padding-bottom: 4px;
    }}
    .column {{
      min-height: 260px;
      border: 1px solid var(--line);
      background: #eef1f5;
      border-radius: 8px;
      padding: 10px;
    }}
    .column header {{
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 10px;
    }}
    .column h2 {{ margin: 0; font-size: 14px; font-weight: 700; }}
    .column header span {{
      color: var(--muted);
      font-size: 12px;
      border: 1px solid var(--line);
      background: var(--panel);
      border-radius: 999px;
      padding: 2px 7px;
    }}
    .card {{
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 10px;
      margin-bottom: 8px;
      box-shadow: 0 1px 2px rgba(24, 27, 32, 0.04);
    }}
    .card-title {{ font-size: 14px; font-weight: 650; }}
    .card-meta {{ margin-top: 6px; color: var(--muted); font-size: 12px; }}
    .empty {{ color: var(--muted); font-size: 13px; margin: 8px 2px; }}
    .lower {{
      display: grid;
      grid-template-columns: minmax(0, 2fr) minmax(280px, 1fr);
      gap: 16px;
      margin-top: 18px;
    }}
    .panel {{
      background: var(--panel);
      border: 1px solid var(--line);
      border-radius: 8px;
      padding: 14px;
      overflow: auto;
    }}
    h3 {{ margin: 0 0 10px; font-size: 16px; }}
    table {{ width: 100%; border-collapse: collapse; font-size: 13px; }}
    th, td {{ border-top: 1px solid var(--line); padding: 8px; text-align: left; vertical-align: top; }}
    th {{ color: var(--muted); font-weight: 650; }}
    .badge {{
      display: inline-block;
      border-radius: 999px;
      padding: 2px 8px;
      color: #fff;
      font-size: 12px;
      white-space: nowrap;
      background: var(--ready);
    }}
    .in-progress {{ background: var(--progress); }}
    .blocked {{ background: var(--blocked); }}
    .review {{ background: var(--review); }}
    .done {{ background: var(--done); }}
    ol {{ margin: 0; padding-left: 20px; color: var(--muted); font-size: 13px; }}
    li {{ margin-bottom: 8px; }}
    @media (max-width: 900px) {{
      main {{ padding: 16px; }}
      .top, .lower {{ display: block; }}
      .stats {{ justify-content: flex-start; margin-top: 12px; }}
      .board {{ grid-template-columns: repeat(5, 220px); }}
      .panel {{ margin-top: 14px; }}
    }}
  </style>
</head>
<body>
  <main>
    <section class="top">
      <div>
        <h1>{html.escape(title)}</h1>
        <div class="sub">Generated {html.escape(generated)}. Auto-refreshes every 15 seconds. Source: {html.escape(str(path))}</div>
      </div>
      <div class="stats">
        <div class="stat"><strong>{total}</strong><span>Total</span></div>
        <div class="stat"><strong>{counts["Blocked"]}</strong><span>Blocked</span></div>
        <div class="stat"><strong>{counts["Review"]}</strong><span>Review</span></div>
        <div class="stat"><strong>{counts["Done"]}</strong><span>Done</span></div>
      </div>
    </section>
    <section class="board">
      {''.join(column_html)}
    </section>
    <section class="lower">
      <div class="panel">
        <h3>Slice Index</h3>
        <table>
          <thead><tr><th>ID</th><th>Slice</th><th>Blocks</th><th>Type</th><th>Workspace</th><th>Status</th><th>Verification</th></tr></thead>
          <tbody>{''.join(row_html)}</tbody>
        </table>
      </div>
      <div class="panel">
        <h3>Event Log</h3>
        <ol>{''.join(event_html)}</ol>
      </div>
    </section>
  </main>
</body>
</html>
"""
    output.write_text(document)
    return output


def rebuild_kanban(text: str, cards: dict[str, list[str]]) -> str:
    lines = [
        "## Kanban Board",
        "",
        "Move slice IDs across columns as work changes.",
        "",
    ]
    for column in COLUMNS:
        lines.append(f"### {column}")
        lines.extend(cards[column])
        lines.append("")
    new_section = "\n".join(lines)

    start = text.find("## Kanban Board")
    end = text.find("## Slice Index", start)
    if start == -1 or end == -1:
        raise SystemExit("Board must contain ## Kanban Board before ## Slice Index")
    return text[:start] + new_section + text[end:]


def update_index(text: str, slice_id: str, status: str, workspace: str, note: str) -> str:
    output = []
    for line in text.splitlines():
        if line.startswith("|"):
            parts = [part.strip() for part in line.strip().strip("|").split("|")]
            if len(parts) >= 7 and parts[0] == slice_id:
                parts[4] = workspace or parts[4]
                parts[5] = status
                if note:
                    parts[6] = note
                line = "| " + " | ".join(parts) + " |"
        output.append(line)
    return "\n".join(output) + ("\n" if text.endswith("\n") else "")


def ensure_event_log(text: str) -> str:
    if "\n## Event Log\n" in text:
        return text
    if not text.endswith("\n"):
        text += "\n"
    return text + "\n## Event Log\n"


def append_event(text: str, slice_id: str, status: str, workspace: str, note: str) -> str:
    text = ensure_event_log(text)
    timestamp = dt.datetime.now().strftime("%Y-%m-%d %H:%M")
    actor = workspace or "unknown workspace"
    detail = f" - {note}" if note else ""
    return text.rstrip() + f"\n- {timestamp}: {slice_id} -> {status} by {actor}{detail}\n"


def update_board(path: Path, action: str, slice_id: str, workspace: str, note: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    lock = lock_path(path)
    with lock.open("a+") as lock_file:
        fcntl.flock(lock_file, fcntl.LOCK_EX)
        text = read_board(path)
        titles = parse_index_titles(text)
        if slice_id not in titles:
            known = ", ".join(sorted(titles)) or "none"
            raise SystemExit(
                f"Slice ID {slice_id} is not in the Slice Index for {path}. "
                f"Known slices: {known}"
            )
        title = titles[slice_id]
        status = STATUS_BY_ACTION[action]
        cards = parse_current_cards(text)

        for column in COLUMNS:
            cards[column] = [line for line in cards[column] if card_id(line) != slice_id]
        cards[status].append(card_line(slice_id, title, status, workspace, note))

        text = rebuild_kanban(text, cards)
        text = update_index(text, slice_id, status, workspace, note)
        text = append_event(text, slice_id, status, workspace, note)
        write_board(path, text)
        render_html(path)


def workspace_name(explicit: str | None) -> str:
    if explicit:
        return explicit
    if os.environ.get("CONDUCTOR_WORKSPACE_NAME"):
        return os.environ["CONDUCTOR_WORKSPACE_NAME"]
    return Path.cwd().name


def main() -> int:
    parser = argparse.ArgumentParser(description="Update a markdown slice board.")
    parser.add_argument("action", choices=("path", "html", "claim", "block", "review", "done"))
    parser.add_argument("feature", help="Feature slug, such as chat-response-guarantee")
    parser.add_argument("slice_id", nargs="?", help="Slice ID, such as 001")
    parser.add_argument("--board", help="Explicit path to slices.md")
    parser.add_argument("--output", help="Explicit path for generated HTML")
    parser.add_argument("--workspace", help="Workspace name to record")
    parser.add_argument("--note", default="", help="Status note or verification summary")
    args = parser.parse_args()

    path = board_path(args.feature, args.board)
    if args.action == "path":
        print(path)
        return 0
    if args.action == "html":
        output = Path(args.output).expanduser() if args.output else None
        print(render_html(path, output))
        return 0
    if not args.slice_id:
        raise SystemExit("slice_id is required for claim, block, review, and done")

    update_board(
        path=path,
        action=args.action,
        slice_id=args.slice_id,
        workspace=workspace_name(args.workspace),
        note=args.note,
    )
    print(f"{args.slice_id} -> {STATUS_BY_ACTION[args.action]} in {path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
