# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/gnumeric/gnumeric-1.10.13.ebuild,v 1.8 2011/03/22 19:56:44 ranger Exp $

EAPI="3"
GCONF_DEBUG="no"
PYTHON_DEPEND="python? 2:2.4"

inherit gnome2 flag-o-matic python

DESCRIPTION="Gnumeric, the GNOME Spreadsheet"
HOMEPAGE="http://projects.gnome.org/gnumeric/"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86 ~x86-fbsd"

IUSE="gnome perl python"
# Missing gnome-extra/libgnomedb required version in tree

# lots of missing files, wait for next release
# also fails tests due to 80-bit long story
RESTRICT="test"

RDEPEND="sys-libs/zlib
	app-arch/bzip2
	>=dev-libs/glib-2.12:2
	>=gnome-extra/libgsf-1.14.19[gnome?]
	>=x11-libs/goffice-0.8.10:0.8
	>=dev-libs/libxml2-2.4.12:2
	>=x11-libs/pango-1.12

	>=x11-libs/gtk+-2.18:2
	x11-libs/cairo[svg]

	gnome? (
		>=gnome-base/gconf-2:2
		>=gnome-base/libgnome-2
		>=gnome-base/libgnomeui-2
		>=gnome-base/libbonobo-2.2
		>=gnome-base/libbonoboui-2.2 )
	perl? ( dev-lang/perl )
	python? ( >=dev-python/pygtk-2 )
"
#	libgda? (
#		>=gnome-extra/libgda-4.1.1:4.0
#		>=gnome-extra/libgnomedb-3.99.6:4.0 )
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	>=dev-util/pkgconfig-0.18
	app-text/scrollkeeper"

pkg_setup() {
	G2CONF="${G2CONF}
		--enable-ssindex
		--disable-static
		--without-gda
		--with-zlib
		$(use_with perl)
		$(use_with python)
		$(use_with gnome)"
	DOCS="AUTHORS BEVERAGES BUGS ChangeLog HACKING MAINTAINERS NEWS README"
	use python && python_set_active_version 2
}

src_install() {
	gnome2_src_install

	# Remove useless .la files
	find "${ED}" -name "*.la" -delete || die
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_need_rebuild
}
