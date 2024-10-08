# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_distutilscross"
PKG_VERSION="0.1"
PKG_SHA256="4ed3fb427708c8a3ed5fe9c599532480f581078a1e0aec0e50f40eb58e9f0015"
PKG_LICENSE="GPL"
PKG_SITE="https://pypi.org/project/distutilscross/"
PKG_URL="https://files.pythonhosted.org/packages/source/d/distutilscross/distutilscross-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_HOST="Python3:host setuptools:host"
PKG_LONGDESC="distutilscross enhances distutils to support Cross Compile of Python extensions"
PKG_TOOLCHAIN="manual"

makeinstall_host() {
  export DONT_BUILD_LEGACY_PYC=1
  exec_thread_safe python setup.py install --prefix=${TOOLCHAIN}
}
