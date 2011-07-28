# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/pkcs11-data/pkcs11-data-0.7.4.ebuild,v 1.2 2011/04/13 19:07:41 flameeyes Exp $

EAPI=4

DESCRIPTION="Utilities for PKCS#11 data object manipulation in"
HOMEPAGE="http://sites.google.com/site/alonbarlev/pkcs11-utilities"
SRC_URI="http://pkcs11-tools.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=dev-libs/pkcs11-helper-1.02"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF}
}
