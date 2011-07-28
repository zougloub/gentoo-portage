# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bsign/bsign-0.4.5.ebuild,v 1.11 2010/07/16 22:23:26 hwoarang Exp $

EAPI=2
inherit autotools toolchain-funcs

DESCRIPTION="embed secure hashes (SHA1) and digital signatures (GNU Privacy Guard) into files"
HOMEPAGE="http://packages.debian.org/sid/bsign"
SRC_URI="mirror://debian/pool/main/b/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ~x86 ~x86-linux"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${P}-non-gnu.patch # for Darwin, BSD, Solaris, etc.

	if ! use static-libs || [[ ${CHOST} == *-darwin* ]]; then
		sed -i -e '/^LFLAGS/s/-static//' Makefile.in
	fi

	sed -i -e "/^CFLAGS/d" \
		-e "/^CXXFLAGS/d" configure.in
	eautoreconf
	tc-export CC CXX
}

src_install() {
	dobin bsign_sign bsign_verify bsign_hash bsign_check || die
	newbin o/bsign-unstripped bsign || die
	doman bsign.1 || die
	dodoc README || die
}
