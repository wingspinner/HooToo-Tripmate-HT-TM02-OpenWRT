HooToo-Tripmate-HT-TM02-OpenWRT
===============================

Patches, files and instructions to upgrade the HT-TM02 to OpenWRT


REQUIREMENTS and INSTRUCTIONS
==================


WARRANTY
We should all know this but it's worth mentioning...These materials are strictly
experimental and provided for educational and recreational purposes only. There
is no warranty of any kind. Modifying any piece of equipment is risky and can
damage your devices and related equipment rendering them unusable (bricking).
You do so at your own risk. For support the best place to go is the openwrt wiki
and online forum (http://openwrt.org)

Ok, on with the show....

REQUIREMENTS

- A reasonably sized USB Flash stick (preferrably a nice, clean, new >=1gb one)
- PC - any OS and browser
- Ethernet cable

INSTRUCTIONS

To install OpenWRT on the TM02 we replaced the UBoot bootloader with one more
compatible with the OpenWRT partitioning scheme. The hard way to do this is to
solder a 3v USB<->Serial cable to the board, setup a tftp server and replace it
using tftp, then reboot and us that to  burn the OpenWRT sysupgrade image to the
correct MTD partition using tftp. That's how I did it the first time.

Since then, I have studied and now understand the factory HooToo upgrade images
and have used that knowledge to create an OpenWRT image that's compatible with
the HooToo factory GUI software. In OpenWRT parlance this is caled a "factory"
image. Now it's easy to do the conversion/upgrade and it shouldn't take more
than 10-15 minutes. Here's the process....

1. Connect the TM02 to power with it's mode switch in the AP mode. That's the
switch selection that has the icon with an image of the world connected to a
network. Wait for it to boot up as indicated by it showing up as an AP in your
wifi scan. Connect to it. The password is "11111111".

2. Once you are connected, open your browser and browse to the IP address
10.10.10.254 . The Hootoo GUI should appear. Bypass the setup wizard by closing
it's popup window.

3. Insert a USB flash memory stick (preferrably an empty one you can dedicate to
this purpose) into the TM02. Wait for the popup window confirming that the TM02
has recognized the stick. Make sure the stick is properly mounted by clicking on
the "Explore" menu item and viewing the directory of the stick.

4. Now go to the "System" menu, select the firmware upgrade menu item, and then
upgrade the TM02 using the "fw-OpenWRT-HooToo-TM02-2.000.018" file from the
"ramips_openwrt" directory of this repository
(https://github.com/wingspinner/HooToo-Tripmate-HT-TM02-OpenWRT)

5. WAIT until the timer popup times out before disconnecting the TM02 power as
it takes time to write and verify the entire on-board flash MTD.

6. Connect an ethernet cable between your PC and the TM02. Set your PC for DHCP
and then power-on the TM02. If the upgrade worked, you'll see both LED's light
up. That's the new UBoot. When it starts to boot the kernel they will go out. 
They may or may not come back on during the boot process. After about 30 seconds
it should be booted into OpenWRT. Later, you can configure the LED's to do
something more useful.

7. LUCI should be up and running so browse to 192.168.1.1 and configure to your
hearts content. 

INITIAL CONFIGURATION

OpenWRT is initially configured as an Internet access device (i.e. routed client
bridge) so you should be able to add the wifi interface (WWAN) and associate
with your wifi network. Relayd is already present so you may want to create that
interface as well. I'm using a TM02 freshly upgraded as a client bridge with
relayd as I write this - works well.


WHAT HAPPENS DURING THEY UPGRADE AND WHY YOU NEED A USB FLASH STICK

The TM02 with the factory software doesn't have enough RAM to untar/ungzip and
assemble the complete TM02 flash MTD image for the upgrade so it requires a USB
flash stick to use as workspace. So does the new loader. Having a clean USB
flash stick plugged in is required.

The first thing the loader does is shutdown various services that might
interfere with the flashing process and perhaps free up some RAM. Then it
creates a complete backup of the factory flash MTD device written to your USB
flash stick. It copys the entire TM02 MTD device as one file as well as each
partition seperately to seperate files. The files are named appropriately and
will be under the "HT_FLASH" directory on the stick. You can use this to revert
back to factory if you wish. I'll writeup some instructions later for this. 

Next the loader seperates the OpenWRT sysupgrade image and the new UBoot image
from the overall upgrade file and  ungzips and untars them. Then it assembles a
new MTD device flash image which includes the new UBoot, the original factory
"config" and "factory" MTD partitions, and the new OpenWRT sysupgrade image.
This is then written to the TM02 MTD. A copy of this is also written to your
flash stick as "openwrt.bin". Once that's all done it executes a "reboot"
command. (Note:This doesn't appear to happen. Probably because the MTD has been
completely overwritten as well as various services have been shutdown and
removed from RAM.)



LEGAL
The files on this site and these instructions are licensed under a  Creative
Commons Attribution-ShareAlike 3.0 Unported License
http://creativecommons.org/licenses/by-sa/3.0/ . OpenWRT sources and binarys are
subject to the licensing requirements of OpenWRT.org. Some files may fall under
other types of licenses. 

No proprietary source code, binary files, or other intellectual property is
included to the best of our knowledge.
Please notify us if you find otherwise and we will take appropriate action. 
