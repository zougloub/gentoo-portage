# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/robotfindskitten/robotfindskitten-1.4142135.349.ebuild,v 1.9 2009/01/29 02:33:12 mr_bones_ Exp $

inherit games

DESCRIPTION="Help robot find kitten"
HOMEPAGE="http://robotfindskitten.org/"
SRC_URI="mirror://sourceforge/rfk/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="sys-libs/ncurses"

src_install() {
	dogamesbin src/robotfindskitten || die "dogamesbin failed"
	doinfo doc/robotfindskitten.info
	dodoc AUTHORS BUGS ChangeLog NEWS README
	prepgamesdirs
}
