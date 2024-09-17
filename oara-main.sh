#!/bin/bash

export QT_QPA_PLATFORM=wayland 
export SCORE_AUDIO_BACKEND=dummy

exec /home/scrime/ossia/build-sep-2024/build-release/ossia-score --autoplay --no-gui /home/scrime/oara/oara-main.score

