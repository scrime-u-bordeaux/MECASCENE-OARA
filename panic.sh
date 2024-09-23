#!/bin/bash

export QT_QPA_PLATFORM=xcb 
export SCORE_AUDIO_BACKEND=dummy

export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia

exec /home/scrime/ossia/build-sep-2024/build-release/ossia-score  --no-restore /home/scrime/oara/panic.score --autoplay --no-gui
