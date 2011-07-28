# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-da/ispell-da-1.6.18.ebuild,v 1.3 2008/11/03 18:27:18 pva Exp $

inherit multilib

DESCRIPTION="A danish dictionary for ispell"
HOMEPAGE="http://da.speling.org/"
SRC_URI="http://da.speling.org/filer/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="app-text/ispell"

src_compile() {
	emake || die
}

src_install() {
	insinto /usr/$(get_libdir)/ispell
	doins dansk.aff dansk.hash || die
	dodoc README contributors
}
