#!/usr/bin/env bash

echo "Please choose your primary web interface. Here is a list of them:"
echo "$(ifconfig)"
echo ""
read primary_interface
echo "Also enter your ROUTER IP."
read router_ip
echo "Also enter your DNS IP. This is usually your router's ip if DHCP is enabled on it."
read dns_ip
echo "Explicity block any IPs? It is recommended to block your modem's internal IP. Excepts a comma-seperated list"
echo "such as 192.168.100.1,192.168.0.0"
read block_ip_list

function denyall {
  #TEMPORARY DROP iptables
  iptables -P INPUT DROP
  iptables -P OUTPUT DROP
  iptables -P FORWARD DROP
  ip6tables -P INPUT DROP
  ip6tables -P OUTPUT DROP
  ip6tables -P FORWARD DROP

}

function flushrules {
  iptables -F
}

function webrules {
  # explicit block list

  #output chain
  iptables -A OUTPUT  -p udp -o ${primary_interface} -d ${dns_ip} --dport 53 -j ACCEPT
  iptables -A OUTPUT  -p udp -o ${primary_interface} -d ${router_ip} --dport 67 -m conntrack -j ACCEPT
  iptables -A OUTPUT  -p tcp -o ${primary_interface} -m multiport --dports 80,443 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT

  #forward chain
  iptables -A FORWARD -i lo -j ACCEPT
  #input chain
  iptables -A INPUT -p tcp -i ${primary_interface} -m multiport --sports 80,443 -m conntrack --ctstate ESTABLISHED -j ACCEPT
  iptables -A INPUT -p udp -i ${primary_interface} -s ${dns_ip} --sport 53 -j ACCEPT
  iptables -A INPUT -p udp -i ${primary_interface} -s ${router_ip} --sport 67 -j ACCEPT

}

function backup {
  echo "Fuck your existing iptables for now. Backing up to /usr/backup/iptables.rules.backup: $(iptables -L -n -v)"
  iptables-save > /usr/iptables.rules.backup
  # iptables6-save > /usr/backup/iptables6.rules.backup
  iptables -F
}

backup
flushrules
denyall
webrules

echo "Setting up iptables-persistent"
apt-get -y install netfilter-persistent
service netfilter-persistent start
/etc/init.d/netfilter-persistent save
