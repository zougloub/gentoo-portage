# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/squidview/squidview-0.79.ebuild,v 1.1 2011/07/17 15:52:46 flameeyes Exp $

EAPI="4"

DESCRIPTION="Interactive console program to analyse squid logs"
HOMEPAGE="http://www.rillion.net/squidview/"
SRC_URI="http://www.rillion.net/squidview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"

src_install() {
	emake DESTDIR="${D}" install

	# BUGS and HOWTO are installed also as part of the Makefile, but the
	# program expects them at the right location, so we can't get rid of
	# them there for now.
	dodoc README AUTHORS BUGS HOWTO
}
