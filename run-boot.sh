#!/bin/sh

### AES67 set-up ###
THE_DEVICE=enp59s0
if ip a show dev enp59s0; then
  echo ...
  THE_DEVICE=enp59s0
elif ip a show dev enp60s0; then
  echo ...
  THE_DEVICE=enp60s0
fi

echo Device: $THE_DEVICE
THE_IP=$(ip a show dev enp59s0 | grep 169.254.174.241)
#if [[ "$THE_IP" == "" ]]; then
#  zenity --warning --text="Erreur: la carte reseau n'est pas configuree correctement. Verifier que le reseau est mis sur 'dante'" --width=400
#  exit 1
#fi

sudo sysctl -w net.ipv4.igmp_max_memberships=66

sudo insmod /home/scrime/oara/aes67-linux-daemon/3rdparty/ravenna-alsa-lkm/driver/MergingRavennaALSA.ko

sudo /usr/sbin/ptp4l -i $THE_DEVICE -l7 -E -S &

cat /home/scrime/oara/aes67-linux-daemon/test/daemon.conf | sed "s/THE_DEVICE/$THE_DEVICE/g" >  /home/scrime/oara/aes67-linux-daemon/test/daemon-$THE_DEVICE.conf

sleep 10

/home/scrime/oara/aes67-linux-daemon/daemon/aes67-daemon -c /home/scrime/oara/aes67-linux-daemon/test/daemon-$THE_DEVICE.conf &

sleep 10


jackd -S  -d alsa -r 48000 -C none -P plughw:RAVENNA -p 48 -n 1 -i 0 -o 48 &

sleep 5

### Remote control setup ###
# 1. Open Stage Control
/home/scrime/open-stage-control/open-stage-control -n --config-file /home/scrime/oara/open-stage-control-config.config &

sleep 1

# 2. ossia
QT_QPA_PLATFORM=minimal SCORE_AUDIO_BACKEND=dummy /home/scrime/ossia/build-sep-2024/build-release/ossia-score /home/scrime/oara/phone-control-entrypoint.score --autoplay --no-gui

# /home/scrime/ossia/build-score-llvm14/ossia-score /home/scrime/oara/entrypoint.score &

#sleep 5

#export SC_JACK_DEFAULT_INPUTS="ossia score"

#sclang /home/scrime/oara/Mecascene-final.scd
