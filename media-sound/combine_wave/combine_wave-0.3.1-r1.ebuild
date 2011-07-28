# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/combine_wave/combine_wave-0.3.1-r1.ebuild,v 1.2 2011/04/26 12:58:41 angelos Exp $

EAPI="2"

inherit eutils toolchain-funcs

IUSE=""

DESCRIPTION="sync up 2 audio ch. and/or combine 2 mono audio ch. into one stereo wave ch."
HOMEPAGE="http://panteltje.com/panteltje/dvd/"
SRC_URI="http://panteltje.com/panteltje/dvd/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	# fix makefile
	sed -i -e "s:gcc:\$(CC):g" -e "s:= -O2:+=:g" \
		-e "s:\( -o \): \$(LDFLAGS)\1:g" Makefile
	epatch "${FILESDIR}"/${P}-overflow.patch
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	dobin combine_wave || die
	dodoc CHANGES README combine_wave.man
}
