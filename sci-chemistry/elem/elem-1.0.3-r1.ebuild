# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/elem/elem-1.0.3-r1.ebuild,v 1.7 2010/09/06 12:44:01 xarthisius Exp $

inherit toolchain-funcs

DESCRIPTION="periodic table of the elements"
HOMEPAGE="http://elem.sourceforge.net/"
SRC_URI="mirror://sourceforge/elem/${PN}-src-${PV}-Linux.tgz"
LICENSE="GPL-2"
KEYWORDS="amd64 sparc x86"
SLOT="0"
IUSE=""

DEPEND="x11-libs/xforms"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -e 's:\(^LIBS = .*\):\1 -lXpm:' -i Makefile || die "sed failed"
}

src_compile () {
	emake COMPILER="$(tc-getCC)" FLAGS="${CFLAGS}" all || die "Build failed."
}

src_install () {
	into /usr
	dobin elem elem-de elem-en
	dohtml -r doc/*
}
