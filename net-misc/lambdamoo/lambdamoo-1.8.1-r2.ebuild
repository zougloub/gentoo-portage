# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/lambdamoo/lambdamoo-1.8.1-r2.ebuild,v 1.1 2010/09/20 02:17:54 jer Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="networked mud that can be used for different types of collaborative software"
HOMEPAGE="http://sourceforge.net/projects/lambdamoo/"
SRC_URI="mirror://sourceforge/lambdamoo/LambdaMOO-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

DEPEND="sys-devel/bison"
RDEPEND=""

S=${WORKDIR}/MOO-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-enable-outbound.patch
	sed -i Makefile.in \
		-e '/ -o /s|$(CFLAGS)|& $(LDFLAGS)|g' \
		|| die "sed Makefile.in"
	eautoreconf
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CFLAGS="${CFLAGS} \
		-DHAVE_MKFIFO=1" \
		|| die "emake failed!"
}

src_install() {
	dosbin moo
	insinto /usr/share/${PN}
	doins Minimal.db
	dodoc *.txt README*

	newinitd "${FILESDIR}"/lambdamoo.rc ${PN}
	newconfd "${FILESDIR}"/lambdamoo.conf ${PN}
}
