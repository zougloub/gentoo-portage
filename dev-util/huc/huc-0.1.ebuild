# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/huc/huc-0.1.ebuild,v 1.18 2010/01/15 21:45:56 fauli Exp $

inherit toolchain-funcs

DESCRIPTION="HTML umlaut conversion tool"
SRC_URI="http://www.int21.de/huc/${P}.tar.bz2"
HOMEPAGE="http://www.int21.de/huc/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc sparc x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""

doecho() {
	echo "$@"
	"$@"
}

src_compile() {
	doecho $(tc-getCXX) \
		${LDFLAGS} ${CXXFLAGS} \
		-o ${PN} ${PN}.cpp || die "compile failed"
}

src_install () {
	dobin huc || die "dobin failed"
	dodoc README
}
