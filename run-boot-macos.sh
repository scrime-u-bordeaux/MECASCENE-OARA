#!/bin/bash

pkill open-stage-control
pkill ossia
sleep 1
### Screen ###
#pmset disablesleep 1
#pmset powernap 0
eval "$(/opt/homebrew/bin/brew shellenv)"
displayplacer "id:AEE4E9EB-105B-4F42-9219-AB2BDA16EE83 res:1920x1080 hz:60 color_depth:8 enabled:true scaling:on origin:(0,0) degree:0" "id:818EDFCA-73FA-4545-BA90-6D105A528D5F res:1920x1080 hz:50 color_depth:8 enabled:true scaling:off origin:(1920,0) degree:0" "id:60246636-E052-4369-8A21-3955D3E5D59F res:1920x1080 hz:50 color_depth:8 enabled:true scaling:off origin:(3840,0) degree:0" "id:8EFCB739-A601-4509-8191-C4BA0789960B res:1920x1080 hz:50 color_depth:8 enabled:true scaling:off origin:(5760,0) degree:0"


### Wi-Fi ###
# Setup Wi-Fi network for remote control


### Remote control setup ###
sleep 5
# 1. Open Stage Control
/Applications/open-stage-control.app/Contents/MacOS/open-stage-control -n --config-file /Users/Metascene/oara/open-stage-control-config.config &

# 2. Useful log functions that will message open stage control
log_ok() {
  oscsend localhost 8080 "$1" f 1
}
log_error() {
  oscsend localhost 8080 "$1" f 0
}

check_device() {
  if [[ -e "$1" ]]; then
    log_ok "$2"
  else
    log_error "$2"
  fi
}

check_process() {
  if [[ "1" != "" ]]; then
    log_ok "$2"
  else
    log_error "$2"
  fi
}

sleep 1
date
log_error "/system/lights"
log_error "/system/screen/1"
log_error "/system/screen/2"
log_error "/system/screen/3"
log_error "/system/ethernet"
log_error "/system/ip"
log_error "/system/ravenna"
log_error "/system/aes67"
log_error "/system/jack"
log_error "/system/score"


### Check lights ###
check_device "/dev/cu.usbserial-EN217349" "/system/lights"

### Check screens ###

### AES67 set-up ###

### Start show control ###
sleep 5
#open http://localhost:8080 

export QT_QPA_PLATFORM=cocoa
export SCORE_AUDIO_BACKEND=dummy 
export SCORE_DISABLE_AUDIOPLUGINS=1
export SCORE_DISABLE_LV2=1
export SCORE_DISABLE_LIBRARY=1
export SCORE_AUDIO_DECODING_METHOD=libav_ram
exec "/Applications/ossia score.app/Contents/MacOS/ossia score" /Users/Metascene/oara/phone-control-entrypoint.score --autoplay --no-gui 

