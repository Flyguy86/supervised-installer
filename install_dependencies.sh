#!/bin/bash
set -e
## Make sure Wifi is turn on
sed -i.bak 's|dtoverlay=disable-wifi|#dtoverlay=disable-wifi|' /boot/config.txt

# Install dependencies for HomeAssistant
apt-get install -y apt-utils software-properties-common apparmor-utils apt-transport-https ca-certificates curl dbus jq 

# Install Docker
curl -fsSL get.docker.com | sh

cat /sys/firmware/devicetree/base/model | tee MODEL=$# &> /dev/null

## Get's RaspberryPI 3 or 4 Machine ID and uses for Hass.io docker below.
if [[ ! -z $(echo $MODEL | grep 3) ]]
then
    MACHINE=raspberrypi3
elif [[ ! -z $(echo $MODEL | grep 4) ]]
then
    MACHINE=raspberrypi4
fi
echo $MACHINE
