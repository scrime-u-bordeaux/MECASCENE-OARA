#!/bin/sh

sudo sysctl -w net/ipv4/igmp_max_memberships=66

sudo insmod /home/scrime/oara/aes67-linux-daemon/3rdparty/ravenna-alsa-lkm/driver/MergingRavennaALSA.ko


sudo /usr/sbin/ptp4l -i enp59s0 -l7 -E -S &

sleep 30

/home/scrime/oara/aes67-linux-daemon/daemon/aes67-daemon -c /home/scrime/oara/aes67-linux-daemon/test/daemon.conf &

sleep 30

aplay -M -D plughw:RAVENNA -f S24_LE -r 48000 -c 8 -t raw /dev/random
