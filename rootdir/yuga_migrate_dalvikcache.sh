#!/bin/sh


echo "This script will migrate your dalvik-cache folder from"
echo "the /data partition to /system"
echo ""
echo "Please note that doing so decreases the security of"
echo "your system as /system will be mounted writable"
echo ""
echo "You can disable this feature at any time by"
echo "re-flashing the system partition via fastboot"
echo "Note: your phone will REBOOT after the migration finished!"
echo ""
echo "hit ENTER to continue, CTRL+C to abort"
echo ""

read

if [ -d /system/.pabx ] ; then
	echo "nothing to do, cache was already migrated"
	exit
fi

echo "remounting /system"
mount -o remount,rw /system

echo "creating basic directory structure"

busybox mkdir -m 0771 /system/.pabx
busybox mkdir -m 0771 /system/.pabx/dalvik-cache
busybox mkdir -m 0711 /system/.pabx/dalvik-cache/profiles
chown system.system   /system/.pabx/dalvik-cache/profiles

echo "updating SE-Linux rules"
restorecon -r -F /system

echo "Wiping old dalvik-cache"
rm -rf /data/dalvik-cache/*

echo "rebooting..."
sync
reboot
