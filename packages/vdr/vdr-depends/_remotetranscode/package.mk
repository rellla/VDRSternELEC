# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_remotetranscode"
PKG_VERSION="04abfb2e582a21fb0f8215dce2fe9451a78aff2b"
PKG_SHA256="d350402ef41e334bc5b39b315ab026ee7e45527090c28aa8734651813dc9435d"
PKG_LICENSE="unknown"
PKG_SITE="https://github.com/Zabrimus/remotetranscode"
PKG_URL="https://github.com/Zabrimus/remotetranscode/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="remotetranscode-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain ffmpeg"
PKG_LONGDESC="remotetranscode"
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+speed"

RT_PREFIX="/usr/local"

PKG_MESON_OPTS_TARGET="--prefix=${RT_PREFIX} \
                       --bindir=${RT_PREFIX}/bin \
                       --libdir=${RT_PREFIX}/lib \
                       --libexecdir=${RT_PREFIX}/lib \
                       --sbindir=${RT_PREFIX}/bin"

pre_configure_target() {
   export SSL_CERT_FILE=$(get_install_dir openssl)/etc/ssl/cacert.pem.system
}

pre_make_target() {
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
  # prepare sample archive
  # mkdir -p ${INSTALL}/storage/remotetranscode-sample
  # mv ${INSTALL}/usr/local/movie ${INSTALL}/storage/remotetranscode-sample
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample
  cp -r ${PKG_BUILD}/config/* ${INSTALL}/storage/.config/vdropt-sample

  # copy systemd services
  mkdir -p ${INSTALL}/usr/local/system.d
  cp ${PKG_DIR}/_system.d/* ${INSTALL}/usr/local/system.d

  # zip everything
  mkdir -p ${INSTALL}/usr/local/config
  cd ${INSTALL}
  # zip -qrum9 ${INSTALL}/usr/local/config/web-remotetranscode-sample.zip storage/remotetranscode-sample
  zip -qrum9 ${INSTALL}/usr/local/config/remotetranscode-sample-config.zip storage/.config
}
