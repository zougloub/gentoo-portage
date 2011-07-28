# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bdelta/bdelta-0.1.0.ebuild,v 1.6 2009/07/11 17:35:56 vostorga Exp $

inherit multilib toolchain-funcs eutils

DESCRIPTION="Binary Delta - Efficient difference algorithm and format"
HOMEPAGE="http://deltup.sourceforge.net"
SRC_URI="mirror://sourceforge/deltup/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_unpack() {
	unpack ${A}
	# Set correct libdir
	sed -i -e "s:\(LIBDIR=\${PREFIX}/\)lib:\1$(get_libdir):" \
		"${S}"/Makefile || die "sed failed"
	# Fixing ldflags
	epatch "${FILESDIR}"/${P}-ldflags.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CXXFLAGS="${CXXFLAGS}" -j1 || die "emake failed"
}

src_install() {
	dodir /usr/$(get_libdir)
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README
}
