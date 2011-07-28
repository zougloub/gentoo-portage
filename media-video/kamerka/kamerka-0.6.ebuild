# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kamerka/kamerka-0.6.ebuild,v 1.1 2011/06/19 14:01:46 dilfridge Exp $

EAPI=4
inherit kde4-base

SRC_URI="http://dosowisko.net/${PN}/downloads/${P}.tar.gz"
DESCRIPTION="Simple photo taking application with fancy animated interface"
HOMEPAGE="http://dos1.github.com/kamerka/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-libs/libv4l
	>=x11-libs/qt-core-4.7
	$(add_kdebase_dep phonon-kde)
"
DEPEND=${RDEPEND}

src_prepare() {
	sed -i -e 's/QT_PHONON_LIBRARY/KDE4_PHONON_LIBS/' src/CMakeLists.txt || die
	kde4-base_src_prepare
}
