# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/regexxer/regexxer-0.9.ebuild,v 1.5 2011/03/28 18:43:16 angelos Exp $

EAPI=3
GCONF_DEBUG=no
inherit gnome2

DESCRIPTION="An interactive tool for performing search and replace operations"
HOMEPAGE="http://regexxer.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND=">=dev-cpp/libglademm-2.4:2.4
	>=dev-libs/libsigc++-2:2
	>=dev-cpp/gtkmm-2.6:2.4
	>=dev-libs/libpcre-4
	>=dev-cpp/gconfmm-2.6.1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README
}
