#!/bin/sh

sudo sysctl -w net/ipv4/igmp_max_memberships=66

sudo insmod 3rdparty/ravenna-alsa-lkm/driver/MergingRavennaALSA.ko


sudo /usr/sbin/ptp4l -i enp59s0 -l7 -E -S &

sleep 30

./daemon/aes67-daemon -c ./test/daemon.conf &

sleep 30

aplay -M -D plughw:RAVENNA -f S16_LE -r 48000 -c 2 -t raw /dev/random
