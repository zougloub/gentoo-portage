# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/mtr/mtr-9999.ebuild,v 1.5 2014/12/27 12:20:52 jer Exp $

EAPI=5
inherit eutils autotools fcaps flag-o-matic git-r3

DESCRIPTION="My TraceRoute, an Excellent network diagnostic tool"
HOMEPAGE="http://www.bitwizard.nl/mtr/"
EGIT_REPO_URI="https://github.com/traviscross/mtr.git"
SRC_URI="mirror://gentoo/gtk-2.0-for-mtr.m4.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gtk ipv6"

RDEPEND="
	sys-libs/ncurses
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:2
	)
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

DOCS=( AUTHORS FORMATS NEWS README SECURITY TODO )
FILECAPS=( cap_net_raw /usr/sbin/mtr )

src_unpack() {
	git-r3_src_unpack
	unpack ${A}
}

src_prepare() {
	epatch \
		"${FILESDIR}"/0.80-impl-dec.patch \
		"${FILESDIR}"/0.85-gtk.patch

	sed -i -e "/^\s*xver=/s|$.*)|${EGIT_VERSION:0:8}|" Makefile.am || die

	# Keep this comment and following mv, even in case ebuild does not need
	# it: kept gtk-2.0.m4 in SRC_URI but you'll have to mv it before autoreconf
	mv "${WORKDIR}"/gtk-2.0-for-mtr.m4 gtk-2.0.m4 || die #222909
	AT_M4DIR="." eautoreconf
}

src_configure() {
	# In the source's configure script -lresolv is commented out. Apparently it
	# is needed for 64bit macos still.
	[[ ${CHOST} == *-darwin* ]] && append-libs -lresolv
	econf \
		$(use_enable ipv6) \
		$(use_with gtk)
}
