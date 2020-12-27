#!/bin/bash
set -e

# Enable Wifi Adaptor if disabled
sed -i.bak 's|dtoverlay=disable-wifi|#dtoverlay=disable-wifi|' /boot/config.txt
# Enable internet forwarding from Wifi to Ethernet
sed -i.bak 's|#net.ipv4.ip_forward=1|net.ipv4.ip_forward=1|' /etc/sysctl.conf
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Install dependencies for HomeAssistant
apt-get install -y apt-utils software-properties-common apparmor-utils apt-transport-https ca-certificates curl dbus jq 

## Wait for APT install package manager to release lock
while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
    echo Waiting for other instances of apt to complete...
    sleep 5
done

# Check if Modem Manager is enabled
if cat /sys/firmware/devicetree/base/model | grep '3' > /dev/null 2>&1; then
    echo "raspberrypi3" > ~/machine
elif cat /sys/firmware/devicetree/base/model | grep '4' > /dev/null 2>&1; then
    echo "raspberrypi4" > ~/machine
fi

# Install Docker
curl -fsSL get.docker.com > /var/lib/dietpi/postboot.d/DockerInstaller.sh
echo "rm /var/lib/dietpi/postboot.d/DockerInstaller.sh" >> /var/lib/dietpi/postboot.d/
echo "sleep 5; reboot" >> /var/lib/dietpi/postboot.d/

# Hass.io supervisor installer
curl -sL https://raw.githubusercontent.com/Flyguy86/supervised-installer/master/installer.sh > /var/lib/dietpi/postboot.d/HomeSupervisorInstaller.sh

## Wait for APT install package manager to release lock
while sudo fuser /var/{lib/{dpkg,apt/lists},cache/apt/archives}/lock >/dev/null 2>&1; do
    echo Waiting for other instances of apt to complete...
    sleep 5
done
sleep 5
reboot
