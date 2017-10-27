DNS_SERVER_HOST=${1:-dns}
DNS_SERVER_IP=$(getent hosts $DNS_SERVER_HOST | awk '{ print $1 }')
echo "nameserver $DNS_SERVER_IP" > /etc/resolv.conf
