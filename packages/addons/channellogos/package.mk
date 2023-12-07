# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2017-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="channellogos"
PKG_VERSION="0.0.1"
PKG_REV="0"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://libreelec.tv"
PKG_URL=""
PKG_DEPENDS_TARGET="_MP_Logos"
PKG_SECTION="virtual"
PKG_SHORTDESC="Channellogos"
PKG_LONGDESC="Channellogos for VDR"
PKG_TOOLCHAIN="manual"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="VDR Channellogos"
PKG_ADDON_TYPE="xbmc.service"
PKG_ADDON_IS_STANDALONE="yes"

addon() {
  # create dirs
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/Radio/.Light
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/Radio/.Dark
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/TV/.Light
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/TV/.Dark

  cp -R $(get_build_dir _mediaportal-de-logos)/Radio/.Light ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/Radio
  cp -R $(get_build_dir _mediaportal-de-logos)/Radio/.Dark ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/Radio
  cp -R $(get_build_dir _mediaportal-de-logos)/TV/.Light ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/TV
  cp -R $(get_build_dir _mediaportal-de-logos)/TV/.Dark ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/TV
  cp -R $(get_build_dir _mediaportal-de-logos)/LogoMapping.xml ${ADDON_BUILD}/${PKG_ADDON_ID}/logos/LogoMapping.xml

  export MP_LOGODIR="${ADDON_BUILD}/${PKG_ADDON_ID}/logos"
  export MAPPING="${ADDON_BUILD}/${PKG_ADDON_ID}/logos/LogoMapping.xml"
  export AUTO_UPDATE="false"
  export CLEAN_LINKS="false"
  export TO_LOWER="A-Z"

  touch $(get_build_dir _MP_Logos)/mp_logos.conf
  cd ${MP_LOGODIR}

# Link "Light" variant
  export LOGO_VARIANT="Light"
  export LOGODIR="$(get_build_dir _MP_Logos)/logos${LOGO_VARIANT}"
  mkdir -p ${LOGODIR}
  bash $(get_build_dir _MP_Logos)/mp_logos.sh -c $(get_build_dir _MP_Logos)/mp_logos.conf
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/logos${LOGO_VARIANT}
  cp -R ${LOGODIR} ${ADDON_BUILD}/${PKG_ADDON_ID}

# Link "Dark" variant
  export LOGO_VARIANT="Dark"
  export LOGODIR="$(get_build_dir _MP_Logos)/logos${LOGO_VARIANT}"
  mkdir -p ${LOGODIR}
  bash $(get_build_dir _MP_Logos)/mp_logos.sh -c $(get_build_dir _MP_Logos)/mp_logos.conf
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/logos${LOGO_VARIANT}
  cp -R ${LOGODIR} ${ADDON_BUILD}/${PKG_ADDON_ID}
}
