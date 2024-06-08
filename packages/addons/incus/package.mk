# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="incus"
PKG_VERSION="6.2.0"
PKG_ADDON_VERSION="6.2.0-1"
PKG_SHA256="3593bd8ffd18d347615f451fddcc9658a65e47d4812461cceb9f61c49f568231"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lxc/incus"
PKG_URL="https://github.com/lxc/incus/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain go:host _cowsql _libacl _lxc _squashfs-tools"
PKG_SOURCE_DIR="incus-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_SECTION="tools"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="incus"
PKG_ADDON_TYPE="xbmc.service"

pre_configure_target() {
  	export CFLAGS=$(echo "${CFLAGS} -Wno-use-after-free -I$(get_build_dir _cowsql)/include")
}

make_target() {
    go_configure
    GO=${GOLANG} make  # SHELL='sh -x'
}

makeinstall_target() {
    :
}

addon() {
  go_configure

  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private

  # copy binaries
  cp -P $(get_build_dir incus)/.gopath/bin/linux_${TARGET_KERNEL_ARCH}/* ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp -P $(get_build_dir _squashfs-tools)/squashfs-tools/mksquashfs ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp -P $(get_build_dir _squashfs-tools)/squashfs-tools/unsquashfs ${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  # copy libs
  cp -P  $(get_install_dir _cowsql)/usr/lib/libcowsql.so* \
  		 $(get_install_dir _lxc)/usr/lib/liblxc.so* \
  		 $(get_install_dir _raft)/usr/lib/libraft.so* \
         ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private

  patchelf --add-rpath '${ORIGIN}/../lib.private' ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/incusd
  patchelf --add-rpath '${ORIGIN}/../lib.private' ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/lxc-to-incus
}