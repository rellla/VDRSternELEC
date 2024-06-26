# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="tsduck"
PKG_VERSION="v3.37-3670"
PKG_SHA256="dbb7c654330108c509f2d8a97fe0346e3a1f55ad959e13dcee4a40dd04507886"
PKG_LICENSE="BSD-2-Clause license "
PKG_SITE="https://tsduck.io/"
PKG_URL="https://github.com/tsduck/tsduck/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain tsduck:host"
PKG_DEPENDS_HOST="gcc:host"
PKG_LONGDESC="The MPEG Transport Stream Toolkit"
PKG_TOOLCHAIN="make"
PKG_SECTION="tools"
PKG_BUILD_FLAGS="+speed -sysroot"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="tsduck"
PKG_ADDON_TYPE="xbmc.python.script"

make_host() {
  make -j NOTEST=1 \
          NODTAPI=1 \
          NODEKTEC=1 \
          NOHIDES=1 \
          NOVATEK=1 \
          NOPCSC=1 \
          NOEDITLINE=1 \
          NOGITHUB=1 \
          NOJAVA=1 \
          NODOXYGEN=1 \
          BINDIR=$(get_build_dir tsduck)/native
}

makeinstall_host() {
	:
}

make_target() {

  if [ ${ARCH} = "aarch64" ]; then
  	export CXXFLAGS_EXTRA="-mno-outline-atomics"
  fi

  mkdir -p $(get_build_dir tsduck)/build_addon/usr/bin

  make -j NOTEST=1 \
          NODTAPI=1 \
          NODEKTEC=1 \
          NOHIDES=1 \
          NOVATEK=1 \
          NOPCSC=1 \
          NOEDITLINE=1 \
          NOGITHUB=1 \
          NOJAVA=1 \
          NODOXYGEN=1 \
          NATIVEBINDIR=$(get_build_dir tsduck)/native \
          CROSS_PREFIX=${TOOLCHAIN} \
          CROSS_TARGET=$(basename ${CC} | sed -e "s/-gcc//") \
          SYSROOT=$(get_build_dir tsduck)/build_addon \
          cross install
}

makeinstall_target() {
	:
}

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/{etc/tsduck,bin,lib.private,data}
  	cp -P $(get_build_dir tsduck)/build_addon/usr/bin/* ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/
  	rm ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/tsconfig
	cp -Pr $(get_build_dir tsduck)/build_addon/usr/lib/* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private/
	rm ${ADDON_BUILD}/${PKG_ADDON_ID}/lib.private/libtsduck.a
	cp -P $(get_build_dir tsduck)/build_addon/usr/share/tsduck/{*.names,*.xml} ${ADDON_BUILD}/${PKG_ADDON_ID}/etc/tsduck

	patchelf --add-rpath '${ORIGIN}/../lib.private' ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/*
}
