iptables -A INPUT -p tcp -s 127.0.0.1 -j ACCEPT
iptables -A OUTPUT -p tcp -d 127.0.0.1 -j ACCEPT
