# Voice Mode QA Checklist

Use for voice response, recording, playback, persistence, audio, transcription, or tap-to-listen work.

## Source Of Truth

- Voice spec, production behavior, approved mockup, and saved message rows.

## Surfaces

- Voice mode on mobile first.
- Chat or message screen with playback.
- Transcript, message, or response persistence path.

## Failures To Catch

- Voice response disappears after refresh or route change.
- Playback does not start, stops early, or plays the wrong response.
- Recording controls overlap the keyboard or safe area.
- Voice data stores under the wrong user.

## Browser And Device Checks

- Mobile viewport or real phone when available.
- Start, stop, refresh, and replay a voice response.
- Test blocked microphone permission and normal permission.

## Data Checks

- Verify message, response, transcript, and audio metadata rows if relevant.
- Confirm private voice data is user-scoped.
- Confirm failed audio does not create a false success row.

## Report

- PASS or FAIL for record, response, persistence, playback, permissions, and mobile layout.

## Stop And Ask

- The fix affects safety behavior, retention, vendor contracts, or production voice data.
