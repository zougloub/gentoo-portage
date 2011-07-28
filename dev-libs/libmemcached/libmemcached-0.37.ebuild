# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmemcached/libmemcached-0.37.ebuild,v 1.1 2010/02/01 06:22:16 robbat2 Exp $

EAPI=2

inherit eutils

DESCRIPTION="a C client library to the memcached server"
HOMEPAGE="http://tangent.org/552/libmemcached.html"
SRC_URI="http://download.tangent.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~sparc-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="debug hsieh"

DEPEND="net-misc/memcached"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.28-runtestsasuser.patch"
}

src_configure() {
	econf \
		$(use_with debug debug) \
		$(use_with hsieh hsieh_hash)
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}

src_test() {
	emake library_test libmhashkit_test || die "Tests failed"
}
