opkg update ; opkg install block-mount kmod-fs-ext4 kmod-usb-storage-extras

mount /dev/sda1 /mnt ; tar -C /overlay -cvf - . | tar -C /mnt -xf - ; umount /mnt

block detect > /etc/config/fstab; \
   sed -i s/option$'\t'enabled$'\t'\'0\'/option$'\t'enabled$'\t'\'1\'/ /etc/config/fstab; \
   sed -i s#/mnt/sda1#/overlay# /etc/config/fstab; \
   cat /etc/config/fstab;

echo "Verify install succeeded. Block size for /overlay should be the size of your sd card"
echo ""
echo "$(df)"

read confirm

if[ ${confirm} -eq "y" ];
	then 
		reboot
	fi