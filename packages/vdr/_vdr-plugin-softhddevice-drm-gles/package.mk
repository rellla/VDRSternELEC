# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-softhddevice-drm-gles"

PKG_VERSION="cf56849a7f6f360bde0d0da721eb867296434623"
PKG_SHA256="62344cfda5a505720da57a28a65288e1b981bf197890c5328705cf76f33794d9"
PKG_SITE="https://github.com/rellla/vdr-plugin-softhddevice-drm"
PKG_URL="https://github.com/rellla/vdr-plugin-softhddevice-drm/archive/${PKG_VERSION}.zip"
PKG_BRANCH="drm-atomic-gles-renamed"

PKG_LICENSE="GPL"

PKG_SOURCE_DIR="vdr-plugin-softhddevice-drm-gles-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain glm alsa freetype ffmpeg _vdr libdrm mesa"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr)"
PKG_LONGDESC="VDR Output Device (softhddevice-drm-gles)"
PKG_TOOLCHAIN="manual"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib -L${SYSROOT_PREFIX}/usr/lib"
}

make_target() {
  VDR_DIR=$(get_build_dir _vdr)
  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  make GLES=1
}

makeinstall_target() {
  LOC_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)
  LIB_DIR=${LOC_DIR}/../../lib/vdr
  VDRDIR=${VDR_DIR}

  make VDRDIR=${VDR_DIR} LOCDIR="${LOC_DIR}" LIBDIR="${LIB_DIR}" GLES=1 install
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d
  cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/

  if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
    cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
    rm -Rf ${INSTALL}/storage/.config/vdropt
  fi

  # create config.zip
  VERSION=$(pkg-config --variable=apiversion vdr)
  cd ${INSTALL}
  mkdir -p ${INSTALL}/usr/local/config/
  zip -qrum9 "${INSTALL}/usr/local/config/softhddevice-drm-gles-sample-config.zip" storage
}
