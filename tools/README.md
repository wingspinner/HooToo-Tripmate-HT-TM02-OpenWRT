Files:

-nmkhtimage
This tool creates a HooToo compatible "factory" image which can be used to
upgrade a fresh HooToo TM02 with factor software to OpenWRT. It requires:

1. A ramips rt305x squashfs-sysupgrade binary
2. An rt305x uboot binary (available on this site under "uboot").

This is a tool for advanced users.
I'm providing this tool to help those that wish to create their own OpenWRT
"factory" images using the OpenWRT system builder or their imagebuilder. The
tool requires OSX or Linux. SED and the chksum utilities. Run the tool without
arguments for the command line format.

nmkhtimage is released under the Open Commons license.