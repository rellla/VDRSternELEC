# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_DirectFB2-media-samples"
PKG_VERSION="9705ec243705b83f2f49574da04d531d8dfaeb7e"
PKG_SHA256="e3895b7c0c2abb50b5923e00b6eafd7c9fc5135302effb4b8c3572f08b9e6182"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/directfb2/DirectFB-media-samples"
PKG_URL="https://github.com/directfb2/DirectFB-media-samples/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _directfb2 _DirectFB2-media"
PKG_LONGDESC="DirectFB-media-samples contains simple applications that can be used to test DirectFB media providers."
PKG_SOURCE_DIR="DirectFB2-media-${PKG_VERSION}"
PKG_BUILD_FLAGS="+pic"
PKG_TOOLCHAIN="meson"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
