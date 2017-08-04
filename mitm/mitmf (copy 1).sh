#!/bin/bash

RED='\033[0;31m'
GREY='\033[1;35m'
BLUE='\033[1;29m'
GREEN='\033[1;28m'
TABLES=( $(sudo cat /proc/net/ip_tables_names) )

if [[ $# -lt 3 ]] ; then
  echo -e "${RED} Missing arguments. \n\n USAGE: sudo ./mitmf.sh interface gateway victim [-l LOGTO]"
  echo -e "${RED}================"
  echo -e "Requires: Ruby 2.3.0[gems=>[bettercap]], iptables"
  echo -e "Required ports: Ruby 2.3.0[gems=>[bettercap]], iptables"
  echo -e "Required background process: Beef XSS running on 127.0.0.1:3000"
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
