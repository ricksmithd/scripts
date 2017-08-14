if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Removing Apple's PF rules and replacing with frozen.pf.rules"
mv /etc/pf.anchors/com.apple ~/Desktop/com.apple.anchors.backup
cp com.frozen.pf.rules /etc/pf.anchors/com.frozen.pf.rules

echo "Replacing pf.conf"
mv /etc/pf.conf ~/Desktop/pf.conf.backup
cp pf.conf /etc/pf.conf

echo "Removing default pfctl plist, adding pf startup script"
mv /System/Library/LaunchDaemons/com.apple.pfctl.plist ~/Desktop/pfctl-plist.backup
cp com.apple.pfctl.plist /System/Library/LaunchDaemons/com.apple.pfctl.plist
cp com.frozen.pf-startup.plist /System/Library/LaunchDaemons/com.frozen.pf.plist

chmod +x /System/Library/LaunchDaemons/com.apple.pfctl.plist
chmod +x /System/Library/LaunchDaemons/com.frozen.pf.plist

echo "Rebooting"
reboot 