# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/mhash/mhash-0.9.9.9.ebuild,v 1.2 2010/04/01 08:42:53 abcd Exp $

inherit eutils

DESCRIPTION="library providing a uniform interface to a large number of hash algorithms"
HOMEPAGE="http://mhash.sourceforge.net/"
SRC_URI="mirror://sourceforge/mhash/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Fix for issues in bug #181563
	#epatch "${FILESDIR}/${PN}-0.9.9-mutils-align.patch"

	epatch "${FILESDIR}"/${PN}-0.9.9-fix-mem-leak.patch
	epatch "${FILESDIR}"/${PN}-0.9.9-fix-snefru-segfault.patch
	epatch "${FILESDIR}"/${PN}-0.9.9-fix-whirlpool-segfault.patch
	epatch "${FILESDIR}"/${PN}-0.9.9-autotools-namespace-stomping.patch
}

src_compile() {
	econf \
		--enable-static \
		--enable-shared || die
	emake || die "make failure"
	cd doc && emake mhash.html || die "failed to build html"
}

src_install() {
	dodir /usr/{bin,include,lib}
	make install DESTDIR="${D}" || die "install failure"

	dodoc AUTHORS INSTALL NEWS README TODO THANKS ChangeLog
	dodoc doc/skid* doc/*.c
	dohtml doc/mhash.html || die "dohtml failed"
}
