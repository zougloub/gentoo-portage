# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/xgammon/xgammon-0.98.ebuild,v 1.14 2010/09/06 08:54:07 tupone Exp $

EAPI=2
inherit eutils

DESCRIPTION="very nice backgammon game for X"
HOMEPAGE="http://fawn.unibw-hamburg.de/steuer/xgammon/xgammon.html"
SRC_URI="http://fawn.unibw-hamburg.de/steuer/xgammon/Downloads/${P}a.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}
	app-text/rman
	x11-misc/imake"

S=${WORKDIR}/${P}a

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-broken.patch" \
		"${FILESDIR}/${P}-config.patch" \
		"${FILESDIR}/gcc33.patch"
}

src_configure() {
	xmkmf || die "xmkmf died"
}

src_compile() {
	env PATH=".:${PATH}" emake EXTRA_LDOPTIONS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
