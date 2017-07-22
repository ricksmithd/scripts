#!/bin/bash

RED='\033[0;31m'
GREY='\033[1;35m'
BLUE='\033[1;29m'
GREEN='\033[1;28m'
TABLES=( $(sudo cat /proc/net/ip_tables_names) )

echo -e "${BLUE} Setting up VIM profile"

cp .vimrc ~/

echo -e "Setting strict tables for web browsing"


if [[ $# -lt 3 ]] ; then
  echo -e "${RED} Missing arguments. \n\n USAGE: sudo ./secure-chromebook.sh <interface> <gateway> <dns>"
  exit 1
fi


sudo iptables -F

while getopts ":l:s" opt; do
  case $opt in
    l)
      sudo iptables -t nat -A -p tcp OUTPUT -o lo -j DNAT --to-destination 0.0.0.0
      sudo iptables -t nat -A -p tcp OUTPUT -o lo -j DNAT --to-destination 0.0.0.0
      echo -e "${GREEN} Added localhost rules - caution"
      ;;
    s)
      echo "SUPER SECURE MODE"
      for TABLE in $(sudo cat /proc/net/ip_tables_names)
        do
          echo -e "${BLUE} Trying to remove ${TABLE}"
          sudo iptables -t $TABLE -F
          sudo iptables -t $TABLE -X  
        done
        ;;

    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done


#sudo ip6tables -P INPUT DROP
#sudo ip6tables -P OUTPUT DROP
#sudo ip6tables -P FORWARD DROP

sudo iptables -P INPUT DROP
sudo iptables -P OUTPUT DROP
sudo iptables -P FORWARD DROP

sudo iptables -A OUTPUT -p tcp -o ${1} --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp -o ${1} --dport 443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p udp -o ${1} -d ${3} --dport 53 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
 
sudo iptables -A INPUT -p tcp -i ${1} --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p tcp -i ${1} --sport 443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
sudo iptables -A INPUT -p udp -i ${1} -s ${3} --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT

sudo iptables -A OUTPUT -p udp -o ${1} --dport 67 -j ACCEPT 
sudo iptables -A INPUT -p udp -i ${1} -s ${2} --sport 67 --dport 68 -j ACCEPT

echo -e "${GREY} Saved tables \n ${GREEN} $(sudo iptables-save)"
