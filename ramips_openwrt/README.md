OpenWRT Flash Images for HT-TM02
================================

- openwrt-ramips-rt305x-ht-tm02-squashfs-factory-r42649.bin
This is the original "factory" image I released and have described in previous instructions.
It includes:

	wpad-mini \
        kmod-ledtrig-netdev kmod-ledtrig-timer kmod-leds-gpio kmod-ledtrig-default-on \
        kmod-usb-core kmod-usb-ohci kmod-usb2 kmod-usb-net usbutils \
        kmod-scsi-core kmod-scsi-generic kmod-fs-ext4 \
        kmod-usb-storage kmod-usb-storage-extras block-mount \
        kmod-usb-serial kmod-usb-serial-ftdi kmod-gpio-button-hotplug \
        kmod-nls-cp437 kmod-nls-iso8859-1 kmod-nls-utf8 luci luci-mod-admin-full \
        kmod-app-samba luci-theme-openwrt luci-proto-relay relayd nano \
        fstools 

It has Luci, USB storage, Samba,  USB-serial support and some others to make a fairly
complete system for experimentation. This is a "factory" image meaning you must use it
with the original HooToo firmware. It will remove the HooToo firmware and replace it
with OpenWRT revision 42649. 

- openwrt-ramips-rt305x-ht-tm02-squashfs-factory-r44945-ws.bin
This is the same as above except with the latest (as of this writing 03-23-2015)
OpenWRT trunk revision software.

- openwrt-ramips-rt305x-ht-tm02-squashfs-factory-r44945-basic.bin
This is a basic image based the latest (as of this writing 03-23-2015)
OpenWRT trunk revision software with no additional packages for those who want to
start from scratch.

- packages-r44945
This is the complete set of packages for this revision. Download these for future use.

Please check instructions for how to use these here:
https://forum.openwrt.org/viewtopic.php?pid=248596#p248596