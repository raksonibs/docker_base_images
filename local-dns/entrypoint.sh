#!/bin/ash
set -e

# The host ip address is the same as the internal gateway ip
HOST_IP=$(ip route | grep default | awk '{ print $3 }')
echo "Using host ip address: ${HOST_IP}"

# Replace the host ip in the address conf template, and put the result in the dnsmasq conf dir
rm -f /etc/dnsmasq/10.address.conf
sed "s/HOST_IP/$HOST_IP/g" /opt/10.address.conf > /etc/dnsmasq/10.address.conf

exec $@
