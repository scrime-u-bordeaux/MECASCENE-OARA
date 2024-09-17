#!/bin/sh

### Remote control setup ###
# 1. Open Stage Control
/home/scrime/open-stage-control/open-stage-control -n --config-file /home/scrime/oara/open-stage-control-config.config &

# 2. Useful log functions
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
  if [[ "$(pidof $1)" != "" ]]; then
    log_ok "$2"
  else
    log_error "$2"
  fi
}

sleep 5

### Check lights ###
check_device "/dev/ttyUSB0" "/system/lights"

### Check screens ###
xrandr | grep "DP-1-1 connected" && log_ok "/system/screen/1"
xrandr | grep "DP-1 connected" && log_ok "/system/screen/2"
xrandr | grep "HDMI-1-0 connected" && log_ok "/system/screen/3"

### AES67 set-up ###
THE_DEVICE=enp59s0
if ip a show dev enp59s0; then
  echo ...
  THE_DEVICE=enp59s0
  log_ok "/system/ethernet"
elif ip a show dev enp60s0; then
  echo ...
  THE_DEVICE=enp60s0
  log_ok "/system/ethernet"
else
  log_error "/system/ethernet"
fi

echo Device: $THE_DEVICE
THE_IP=$(ip a show dev enp59s0 | grep 169.254.174.241)
if [[ "$THE_IP" == "" ]]; then
  log_error "/system/ip"
#  zenity --warning --text="Erreur: la carte reseau n'est pas configuree correctement. Verifier que le reseau est mis sur 'dante'" --width=400
#  exit 1
else
  log_ok "/system/ip"
fi

sudo sysctl -w net.ipv4.igmp_max_memberships=66

sudo insmod /home/scrime/oara/aes67-linux-daemon/3rdparty/ravenna-alsa-lkm/driver/MergingRavennaALSA.ko

lsmod | grep MergingRavennaALSA && log_ok "/system/ravenna"

sudo /usr/sbin/ptp4l -i $THE_DEVICE -l7 -E -S &

cat /home/scrime/oara/aes67-linux-daemon/test/daemon.conf | sed "s/THE_DEVICE/$THE_DEVICE/g" >  /home/scrime/oara/aes67-linux-daemon/test/daemon-$THE_DEVICE.conf

sleep 10

/home/scrime/oara/aes67-linux-daemon/daemon/aes67-daemon -c /home/scrime/oara/aes67-linux-daemon/test/daemon-$THE_DEVICE.conf &

sleep 10

check_process aes67-daemon "/system/aes67"

### Start JACK ###
jackd -S  -d alsa -r 48000 -C none -P plughw:RAVENNA -p 48 -n 1 -i 0 -o 48 &

sleep 5

check_process jackd "/system/jack"

sleep 1

### Start show control ###
QT_QPA_PLATFORM=minimal SCORE_AUDIO_BACKEND=dummy /home/scrime/ossia/build-sep-2024/build-release/ossia-score /home/scrime/oara/phone-control-entrypoint.score --autoplay --no-gui &

sleep 3

check_process ossia-score  "/system/score"

fg
