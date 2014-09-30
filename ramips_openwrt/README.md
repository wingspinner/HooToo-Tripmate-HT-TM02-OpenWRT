OpenWRT Flash Images for HT-TM02
================================

These images are a fairly "basic" RT5350 configuration but include luci and USB
storage and USB-serial support. I've included everything here in case you wish
to experiment however the two images of primary interest are:


openwrt-ramips-rt305x-ht-tm02-squashfs-sysupgrade.bin

This is the standard OpenWRT image to be used by LUCI or the sysupgrade utility
or to be programmed into the "Firmware" parition of the SDI flash device

fw-OpenWRT-HooToo-TM02-2.000.018

This is the "factory" upgrade image to be used by the factory HooToo software to
do the initial upgrade to OpenWRT.It is based on the same binary image as the
normal OpenWRT sysupgrade image but has been re-packaged with a loader, CRC,
etc. such that the factory HooToo software will accept it. The factory HooToo
software is filename sensitive and will reject the file if it's too different
from what it expects. If the TM02 rejects this name try changing it to 
"fw-WiFiPort-HooToo-TM02-2.000.018"