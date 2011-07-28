# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/pconsole/pconsole-1.0-r3.ebuild,v 1.1 2010/10/14 17:33:41 xarthisius Exp $

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Tool for managing multiple xterms simultaneously."
HOMEPAGE="http://www.heiho.net/pconsole/"
SRC_URI="http://www.xs4all.nl/~walterj/pconsole/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="virtual/ssh"

src_prepare() {
	epatch "${FILESDIR}"/${P}-exit-warn.patch
}

src_compile() {
	emake LFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)" || die
}

src_install() {
	dobin pconsole || die
	fperms 4110 /usr/bin/pconsole || die
	dodoc ChangeLog README.pconsole || die
	dohtml public_html/pconsole.html || die
}

pkg_postinst() {
	echo
	ewarn "Warning:"
	ewarn "pconsole installed with suid root!"
	echo
}
