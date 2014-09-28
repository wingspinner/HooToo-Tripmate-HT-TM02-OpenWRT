diff --git a/target/linux/ramips/base-files/etc/board.d/01_leds b/target/linux/ramips/base-files/etc/board.d/01_leds
index 01e2363..4cf49b5 100755
--- a/target/linux/ramips/base-files/etc/board.d/01_leds
+++ b/target/linux/ramips/base-files/etc/board.d/01_leds
@@ -112,6 +112,10 @@ case $board in
 	hlk-rm04)
 		set_wifi_led "rt2800pci-phy0::radio"
 		;;
+        ht-tm02)
+		ucidef_set_led_netdev "eth" "ETH" "ht-tm02:white:status" "eth0"
+		set_wifi_led "ht-tm02:blue:wifi"
+                ;;
 	all0239-3g|\
 	hw550-3g)
 		set_usb_led "hw550-3g:green:usb"
diff --git a/target/linux/ramips/base-files/etc/board.d/02_network b/target/linux/ramips/base-files/etc/board.d/02_network
index e027b3b..c462fd8 100755
--- a/target/linux/ramips/base-files/etc/board.d/02_network
+++ b/target/linux/ramips/base-files/etc/board.d/02_network
@@ -97,6 +97,12 @@ ramips_setup_interfaces()
 		ucidef_add_switch_vlan "switch0" "2" "4 9t"
 		;;
 
+	ht-tm02)
+		ucidef_set_interface_lan "eth0.1"
+		ucidef_add_switch "switch0" "1" "1"
+		ucidef_add_switch_vlan "switch0" "1" "4 6t"
+		;;
+
 	3g-6200n | \
 	dir-610-a1 | \
 	dir-300-b7 | \
@@ -253,6 +259,7 @@ ramips_setup_macs()
 	hlk-rm04 | \
 	mpr-a1 | \
 	mpr-a2 | \
+        ht-tm02 | \
 	dir-300-b7 | \
 	dir-320-b1 | \
 	psr-680w |\
diff --git a/target/linux/ramips/base-files/etc/diag.sh b/target/linux/ramips/base-files/etc/diag.sh
index 9ad7ccb..9752eb2 100755
--- a/target/linux/ramips/base-files/etc/diag.sh
+++ b/target/linux/ramips/base-files/etc/diag.sh
@@ -63,6 +63,9 @@ get_status_led() {
 	hlk-rm04)
 		status_led="hlk-rm04:red:power"
 		;;
+	ht-tm02)
+		status_led="ht-tm02:white:status"
+		;;
 	all0239-3g|\
 	hw550-3g)
 		status_led="hw550-3g:green:status"
diff --git a/target/linux/ramips/base-files/lib/ramips.sh b/target/linux/ramips/base-files/lib/ramips.sh
index bb42ace..68ff509 100755
--- a/target/linux/ramips/base-files/lib/ramips.sh
+++ b/target/linux/ramips/base-files/lib/ramips.sh
@@ -157,6 +157,9 @@ ramips_board_detect() {
 	*"HILINK HLK-RM04")
 		name="hlk-rm04"
 		;;
+	*"HOOTOO HT-TM02")
+		name="ht-tm02"
+		;;
 	*"HAME MPR-A1")
  		name="mpr-a1"
  		;;
diff --git a/target/linux/ramips/base-files/lib/upgrade/platform.sh b/target/linux/ramips/base-files/lib/upgrade/platform.sh
index 407c218..4aec780 100755
--- a/target/linux/ramips/base-files/lib/upgrade/platform.sh
+++ b/target/linux/ramips/base-files/lib/upgrade/platform.sh
@@ -52,6 +52,7 @@ platform_check_image() {
 	hw550-3g | \
 	hg255d | \
 	hlk-rm04 | \
+	ht-tm02 | \
 	ip2202 | \
 	m3 | \
 	m4 | \
diff --git a/target/linux/ramips/dts/HT-TM02.dts b/target/linux/ramips/dts/HT-TM02.dts
new file mode 100644
index 0000000..1f456f0
--- /dev/null
+++ b/target/linux/ramips/dts/HT-TM02.dts
@@ -0,0 +1,104 @@
+/dts-v1/;
+
+/include/ "rt5350.dtsi"
+
+/ {
+	compatible = "HT-TM02", "ralink,rt5350-soc";
+	model = "HOOTOO HT-TM02";
+
+	palmbus@10000000 {
+
+               gpio0: gpio@600 {
+			status = "okay";
+               };
+               
+		spi@b00 {
+			status = "okay";
+			m25p80@0 {
+				#address-cells = <1>;
+				#size-cells = <1>;
+				compatible = "mx25l6405d";
+				reg = <0 0>;
+				linux,modalias = "m25p80", "mx25l6405d";
+				spi-max-frequency = <10000000>;
+
+				partition@0 {
+					label = "u-boot";
+					reg = <0x0 0x30000>;
+					read-only;
+				};
+
+				partition@30000 {
+					label = "u-boot-env";
+					reg = <0x30000 0x10000>;
+					read-only;
+				};
+
+				factory: partition@40000 {
+					label = "factory";
+					reg = <0x40000 0x10000>;
+					read-only;
+				};
+
+				partition@50000 {
+					label = "firmware";
+					reg = <0x50000 0x7b0000>;
+				};
+			};
+		};
+	};
+
+	pinctrl {
+		state_default: pinctrl0 {
+			gpio {
+				ralink,group = "i2c", "jtag", "uartf";
+				ralink,function = "gpio";
+			};
+		};
+	};
+
+	ethernet@10100000 {
+		mtd-mac-address = <&factory 0x4>;
+	};
+
+	esw@10110000 {
+		ralink,portmap = <0x3f>;
+	};
+
+	wmac@10180000 {
+		ralink,mtd-eeprom = <&factory 0>;
+	};
+
+	ehci@101c0000 {
+		status = "okay";
+	};
+
+	ohci@101c1000 {
+		status = "okay";
+	};
+
+	gpio-leds {
+		compatible = "gpio-leds";
+		wifi  {
+			label = "ht-tm02:blue:wifi";
+			gpios = <&gpio0 7 1>;
+		};
+		status  {
+			label = "ht-tm02:yellow:status";
+			gpios = <&gpio0 12 1>;
+		};
+
+	};
+
+	gpio-keys-polled {
+		compatible = "gpio-keys-polled";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		poll-interval = <20>;
+		wps {
+			label = "reset";
+			gpios = <&gpio0 10 1>;
+			linux,code = <0x198>;
+		};
+	};
+};
diff --git a/target/linux/ramips/image/Makefile b/target/linux/ramips/image/Makefile
index 35057e4..c365d9d 100644
--- a/target/linux/ramips/image/Makefile
+++ b/target/linux/ramips/image/Makefile
@@ -434,6 +434,8 @@ define BuildFirmware/HLKRM04/initramfs
 endef
 Image/Build/Profile/HLKRM04=$(call BuildFirmware/HLKRM04/$(1),$(1),hlk-rm04,HLKRM04,HLK-RM02)
 
+Image/Build/Profile/HT-TM02=$(call BuildFirmware/Default8M/$(1),$(1),ht-tm02,HT-TM02)
+
 Image/Build/Profile/M3=$(call BuildFirmware/Poray4M/$(1),$(1),m3,M3)
 
 Image/Build/Profile/M4=$(call BuildFirmware/PorayDualSize/$(1),$(1),m4,M4)
@@ -598,6 +600,7 @@ define Image/Build/Profile/Default
 	$(call Image/Build/Profile/FREESTATION5,$(1))
 #	$(call Image/Build/Profile/HG255D,$(1))
 	$(call Image/Build/Profile/HLKRM04,$(1))
+	$(call Image/Build/Profile/HT-TM02,$(1))
 	$(call Image/Build/Profile/HW550-3G,$(1))
 	$(call Image/Build/Profile/IP2202,$(1))
 	$(call Image/Build/Profile/M3,$(1))
diff --git a/target/linux/ramips/rt305x/profiles/hootoo.mk b/target/linux/ramips/rt305x/profiles/hootoo.mk
new file mode 100644
index 0000000..27c6b9a
--- /dev/null
+++ b/target/linux/ramips/rt305x/profiles/hootoo.mk
@@ -0,0 +1,24 @@
+#
+# Copyright (C) 2013 OpenWrt.org
+#
+# This is free software, licensed under the GNU General Public License v2.
+# See /LICENSE for more information.
+#
+
+
+define Profile/HT-TM02
+	NAME:=HOOTOO HT-TM02
+	PACKAGES:=\
+		wpad-mini \
+		kmod-ledtrig-netdev kmod-ledtrig-timer kmod-leds-gpio \
+		kmod-usb-core kmod-usb-ohci kmod-usb2 kmod-usb-net \
+		kmod-scsi-core kmod-scsi-generic kmod-fs-ext4 \
+		kmod-usb-storage kmod-usb-storage-extras block-mount
+endef
+
+define Profile/HT-TM02/Description
+	Package set for HOOTOO HT-TM02 board
+endef
+
+$(eval $(call Profile,HT-TM02))
+
