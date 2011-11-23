# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/wyrd/wyrd-1.4.4.ebuild,v 1.5 2011/11/22 18:50:07 tove Exp $

EAPI=2

DESCRIPTION="Text-based front-end to Remind"
HOMEPAGE="http://pessimization.com/software/wyrd/"
SRC_URI="http://pessimization.com/software/wyrd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="unicode"

DEPEND=">=dev-lang/ocaml-3.08
	sys-libs/ncurses[unicode?]
	>=app-misc/remind-03.01"
RDEPEND=${DEPEND}

src_configure() {
	econf \
		$(use_enable unicode utf8)
}

src_install() {
	export STRIP_MASK="/usr/bin/wyrd"
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog || die "dodoc failed"
	dohtml doc/manual.html || die "dohtml failed"
}
