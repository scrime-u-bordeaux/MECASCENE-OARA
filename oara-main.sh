#!/bin/bash
export SCORE_AUDIO_BACKEND=coreaudio
export QT_QPA_PLATFORM=cocoa
exec "/Applications/ossia score.app/Contents/MacOS/ossia score"  --no-restore /Users/Metascene/oara/2025-03-05.score --autoplay --no-gui
