echo "netstat -tulpn"
sudo netstat -tulpn
read confirm_tulpn


echo "netstat -na | grep LIS"
sudo netstat -na | grep LIS
read confirm_netstatna


echo "SHOWING /proc/net/ip_conntrack"
sudo cat /proc/net/ip_conntrack
read proc_conntrack

echo "Grepping logs directory. This may take a while"
cd /var/log

sudo cat * | grep -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b|host"
read confirm_loggrep

sudo find /lib/modules/ -type d -print

