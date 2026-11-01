# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="cefbrowser"
PKG_VERSION="d14517be4a7aecfc3ba0b77831af237721ef48e9"
PKG_SHA256="e08f56498729a0a5fcc1093d5667e91a2e95cc60536dcaba220931c7914fda47"
PKG_LICENSE="LPGL"
PKG_SITE="https://github.com/Zabrimus/cefbrowser"
PKG_URL="https://github.com/Zabrimus/cefbrowser/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="cefbrowser-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain atk libxml2 cups cef-at-spi2-core \
                    cef-libXcomposite cef-libXdamage cef-libXfixes cef-libXrandr cef-libXi cef-libXft \
                    cef-libX11 cef-libXext cef-libxcb cef-libXrender \
                    openssl _cef _thrift curl"
PKG_NEED_UNPACK="$(get_pkg_directory _cef)"
PKG_DEPENDS_UNPACK="_cef"
PKG_DEPENDS_CONFIG="_cef"
PKG_LONGDESC="cefbrowser"
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+speed -sysroot +strip"

PKG_REV="4"
PKG_IS_ADDON="yes"
PKG_SECTION="addon"
PKG_ADDON_NAME="cefbrowser"
PKG_ADDON_TYPE="xbmc.service"

# libcef needs libgbm. Use the mesa of the image if it has one (LibreELEC),
# otherwise an own copy in the addon (e.g. CoreELEC with the vendor GPU driver).
if [ "${OPENGLES}" = "mesa" ] || [ "${OPENGL}" = "mesa" ]; then
  CEF_MESA="mesa"
else
  CEF_MESA="_mesa"
fi
PKG_DEPENDS_TARGET+=" ${CEF_MESA}"

# CoreELEC <= 20 (TODO: is this really necessary?)
#if [ "${DISTRONAME}" = "CoreELEC" ] && [ "${OS_MAJOR}" -le "20" ]; then
#   PKG_DEPENDS_TARGET+=" cef-at-spi2-atk"
#fi

case "${ARCH}" in
  arm)     DARCH="arm";;
  aarch64) DARCH="arm64";;
  x86_64)  DARCH="x86_64";;
esac

case "${ARCH}" in
  arm)     DSUBARCH=${TARGET_SUBARCH};;
  aarch64) DSUBARCH=${TARGET_VARIANT};;
  x86_64)  DSUBARCH="x86-64";;
esac

PKG_MESON_OPTS_TARGET="-Darch=${DARCH} -Dsubarch=${DSUBARCH} -Dvdrsternelec=true \
                       --prefix=/usr/local \
                       --bindir=/usr/local/bin \
                       --libdir=/usr/local/lib \
                       --libexecdir=/usr/local/lib \
                       --sbindir=/usr/local/bin \
                       --wrap-mode=default"

pre_configure_target() {
	CEF_DIR="$(get_build_dir _cef)/../../../../cef"
	CEF_VERSION_FILE="$(get_build_dir _cef)/VERSION"
	CEF_VERSION="$(cat ${CEF_VERSION_FILE})"

	export SSL_CERT_FILE=$(get_install_dir openssl)/etc/ssl/cacert.pem.system
	rm -rf ${PKG_BUILD}/subprojects/cef
	ln -s ${CEF_DIR}/cef-${CEF_VERSION}-${ARCH} ${PKG_BUILD}/subprojects/cef
}

pre_make_target() {
	export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
	export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/local/bin
	mkdir -p ${INSTALL}/usr/local/etc
	mkdir -p ${INSTALL}/usr/local/data

	# libcef and its resources are part of the addon cefruntime
	cp -Pr ${PKG_BUILD}/.${TARGET_NAME}/cefbrowser ${INSTALL}/usr/local/bin
	cp -Pr ${PKG_BUILD}/static-content/* ${INSTALL}/usr/local/data
	cp -P  ${PKG_BUILD}/config/sockets.ini ${INSTALL}/usr/local/etc/
}

addon() {
	CEF_VERSION="$(get_pkg_variable _cef PKG_VERSION)"

	# create directories
	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/data
	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/etc
	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/system.d

	# copy cefbrowser
	cp -Pr $(get_install_dir cefbrowser)/usr/local/bin/cefbrowser ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
	cp -Pr $(get_install_dir cefbrowser)/usr/local/data/* ${ADDON_BUILD}/${PKG_ADDON_ID}/data
	cp -P  $(get_install_dir cefbrowser)/usr/local/etc/sockets.ini ${ADDON_BUILD}/${PKG_ADDON_ID}/etc/
	cp -P  ${PKG_DIR}/config/fonts.conf ${ADDON_BUILD}/${PKG_ADDON_ID}/etc/

	# the cefbrowser runs only with the cefruntime of the same CEF version
	echo "${CEF_VERSION}" > ${ADDON_BUILD}/${PKG_ADDON_ID}/etc/cef-version
	for i in ${PKG_DIR}/_system.d/*; do
		sed -e "s|@CEF_VERSION@|${CEF_VERSION}|g" $i > ${ADDON_BUILD}/${PKG_ADDON_ID}/system.d/$(basename $i)
	done
}
