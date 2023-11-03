#!/bin/bash

DEVICE=$1

if [ "$DEVICE" == "RK3399" ]; then
  CONFIG="LibreELEC-master-arm-Rockchip-RK3399"
  SUBDEVICE="rock-pi-4-plus"
elif [ "$DEVICE" == "AMLGX1" ]; then
  CONFIG="LibreELEC-master-arm-AMLGX"
  SUBDEVICE="wetek-play2"
elif [ "$DEVICE" == "AMLGX2" ]; then
  CONFIG="LibreELEC-master-arm-AMLGX"
  SUBDEVICE="odroid-n2"
else
  CONFIG="LibreELEC-master-arm-Rockchip-RK3399"
  SUBDEVICE="rock-pi-4-plus"
fi

export PNG=1
export DEBUG=_cefbrowser,_vdr,_vdr-plugin-web,_vdr-plugin-softhddevice-drm-gles,ffmpeg,_vdr-plugin-skindesigner,_librsvg,_remotetranscode
export VDR=1
export GLES=1

./build.sh \
  -config ${CONFIG} \
  -subdevice ${SUBDEVICE} \
  -extra channellogos,remotetranscode,cefbrowser \
  -addon locale,system-tools \
  -release http://server02
#  -private \
