# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/iksemel/iksemel-1.3.ebuild,v 1.7 2009/05/30 21:41:11 arfrever Exp $

EAPI="2"

inherit autotools eutils

DESCRIPTION="eXtensible Markup Language parser library designed for Jabber applications"
HOMEPAGE="http://code.google.com/p/iksemel"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gnutls"

RDEPEND="gnutls? ( net-libs/gnutls )"
DEPEND="${RDEPEND}
		gnutls? ( dev-util/pkgconfig )"

# http://code.google.com/p/iksemel/issues/detail?id=4
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}/${P}-gnutls-2.8.patch"
	eautoreconf
}

src_configure() {
	econf $(use_with gnutls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HACKING NEWS README TODO
}
