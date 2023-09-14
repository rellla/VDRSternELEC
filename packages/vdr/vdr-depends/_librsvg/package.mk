# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_librsvg"
PKG_VERSION="2.57"
PKG_SHA256="335fe2e0c2cbf1b7bf0668651224a23e135451f0b1793cd813649be2bffa74e8"
PKG_LICENSE="LGPL 2.1"
PKG_SITE="https://gitlab.gnome.org/GNOME/librsvg.git"
PKG_URL="https://download.gnome.org/sources/librsvg/${PKG_VERSION}/librsvg-${PKG_VERSION}.0.tar.xz"
PKG_BRANCH="main"
PKG_DEPENDS_TARGET="toolchain cairo rust gdk-pixbuf pango glib libjpeg-turbo libXft libpng jasper shared-mime-info tiff freetype"
PKG_DEPENDS_CONFIG="shared-mime-info pango gdk-pixbuf pango libXft"
PKG_LONGDESC="A library to render SVG images to Cairo surfaces."

PKG_CONFIGURE_OPTS_TARGET="--enable-introspection=no --disable-pixbuf-loader"
