#!/bin/bash

export SCORE_DISABLE_AUDIOPLUGINS=1
export SCORE_DISABLE_LV2=1
export SCORE_DISABLE_LIBRARY=1
export QT_QPA_PLATFORM=minimal
exec "/Applications/ossia score.app/Contents/MacOS/ossia score"  --no-restore /Users/Metascene/oara/panic.score --autoplay --no-gui
