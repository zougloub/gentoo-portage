# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/killproc/killproc-2.13.ebuild,v 1.2 2009/09/04 18:02:57 mr_bones_ Exp $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="killproc and assorted tools for boot scripts"
HOMEPAGE="http://www.suse.de/"
SRC_URI="ftp://ftp.suse.com/pub/projects/init/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
	cp Makefile{,.orig} -va
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	tc-export CC
	export COPTS=${CFLAGS}
	emake || die "emake failed"
}

src_install() {
	into /
	dosbin checkproc fsync killproc startproc usleep || die "dosbin failed"
	into /usr
	doman *.8 *.1
	dodoc README *.lsm
}
