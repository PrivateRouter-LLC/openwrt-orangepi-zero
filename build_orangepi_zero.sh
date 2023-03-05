#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="21.02.3"
BUILDER="https://downloads.openwrt.org/releases/22.03.2/targets/sunxi/cortexa7/openwrt-imagebuilder-22.03.2-sunxi-cortexa7.Linux-x86_64.tar.xz"
KERNEL_PARTSIZE=128 #Kernel-Partitionsize in MB
ROOTFS_PARTSIZE=4096 #Rootfs-Partitionsize in MB
BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

# Packages are added if no prefix is given, '-packaganame' does not integrate a package
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$KERNEL_PARTSIZE/g" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE/g" .config

make image  PROFILE="xunlong_orangepi-zero" \
           PACKAGES="bash kmod-rt2800-usb rt2800-usb-firmware kmod-cfg80211 kmod-lib80211 kmod-mac80211 kmod-rtl8192cu \
                     base-files block-mount fdisk luci-app-minidlna minidlna samba4-server \
                     samba4-libs luci-app-samba4 wireguard-tools luci-app-wireguard \
                     openvpn-openssl luci-app-openvpn watchcat openssh-sftp-client \
                     luci-base luci-ssl luci-mod-admin-full luci-theme-bootstrap \
                     kmod-usb-storage kmod-usb-ohci kmod-usb-uhci e2fsprogs fdisk resize2fs \
                     htop debootstrap luci-compat luci-lib-ipkg dnsmasq luci-app-ttyd \
                     opkg install base-files busybox ca-bundle cgi-io dnsmasq dropbear e2fsprogs \
                     kernel kmod-crypto-hash kmod-crypto-kpp kmod-crypto-lib-chacha20 kmod-crypto-lib-chacha20poly1305 kmod-crypto-lib-curve25519 kmod-crypto-lib-poly1305 \
                     curl wget rsync file htop lsof less mc tree usbutils bash diffutils \
                     openssh-sftp-server nano luci-app-ttyd kmod-fs-exfat \
                     kmod-ipt-conntrack kmod-ipt-core kmod-ipt-nat kmod-ipt-offload kmod-lib-crc-ccitt kmod-mii kmod-nf-conntrack \
                     urngd usign vpn-policy-routing wg-installer-client wireguard-tools \
                     kmod-usb-core kmod-usb3 dnsmasq dropbear e2fsprogs \
                     kmod-nf-conntrack6 kmod-nf-flow kmod-nf-ipt kmod-nf-ipt6 kmod-nf-nat kmod-nf-reject kmod-nf-reject6 kmod-nls-base kmod-ppp kmod-pppoe kmod-pppox kmod-rtc-sunxi \
                     kmod-tun kmod-udptunnel4 kmod-udptunnel6 kmod-usb-core kmod-usb-net kmod-usb-net-rtl8152 kmod-wireguard \
                     libblkid1 libc libcomerr0 libext2fs2 libf2fs6 libgcc1 libip4tc2 libip6tc2 libiwinfo-data libiwinfo-lua libiwinfo20210430 libjson-c5 \
                     zlib firewall wireless-regdb f2fsck openssh-sftp-server \
                     liblua5.1.5 liblucihttp-lua liblucihttp0 liblzo2 libnl-tiny1 libopenssl1.1 libpthread \
                     librt libsmartcols1 libss2 libubus-lua libuci20130104 \ 
		     libustream-wolfssl20201210 libuuid1 \
                     kmod-usb-wdm kmod-usb-net-ipheth usbmuxd kmod-usb-net-asix-ax88179 \
                     kmod-usb-net-cdc-ether mount-utils kmod-rtl8xxxu kmod-rtl8187 \
                     kmod-rtl8xxxu rtl8188eu-firmware  kmod-rtl8192cu \
                     libxtables12 logd lua luci luci-app-firewall luci-app-openvpn luci-app-opkg \
                     luci-app-wireguard luci-base luci-compat luci-lib-base luci-lib-ip luci-lib-ipkg luci-lib-jsonc luci-lib-nixio kmod-rtl8192cu \
                     adblock luci-app-adblock kmod-fs-squashfs squashfs-tools-unsquashfs squashfs-tools-mksquashfs \
                     kmod-fs-f2fs kmod-fs-vfat git git-http jq" \
            FILES="${BASEDIR}/files/"
            BIN_DIR="${OUTPUT}"
