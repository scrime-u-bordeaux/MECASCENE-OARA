setxkbmap fr oss_latin9
export QT_QPA_PLATFORMTHEME=qt6ct
source /home/scrime/oara-git/screen-layout.sh
nohup /home/scrime/oara/run-boot.sh &

exec i3
