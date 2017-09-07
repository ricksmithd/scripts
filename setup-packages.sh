TBUninstalled=('avahi-daemon' 'cups' 'dnsmasq' 'sshd' 'cups-browsed' 'bluetooth' 'anacron' 'thermald' 'minissdpd' '*exim*')

TBInstalled=('iptables' 'ip6tables' 'netfilter-persistent' 'net-tools' 'git' 'build-essential' 'tlp' 'ip-traf' 'traceroute')

apt-get -y clean
## now loop through the above array
for i in "${TBUninstalled[@]}"
do
   # echo "Looking for $i to terminate"
   # if [ $(dpkg-query -W -f='${Status}' $i 2>/dev/null | grep -c "ok installed") -eq 0 ];
   # then
   #   echo "Found $i - removing"
     apt-get -y remove "$i"
     apt-get -y purge "$i"
   # fi
   # or do whatever with individual element of the array
done
apt-get -y autoremove
echo "Done removing shitty packages. Updating to latest apt software"
apt-get -y update
apt-get -y upgrade

