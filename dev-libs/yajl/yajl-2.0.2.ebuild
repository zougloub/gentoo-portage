# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/yajl/yajl-2.0.2.ebuild,v 1.5 2011/10/17 20:19:18 maekke Exp $

EAPI=4

inherit base cmake-utils

DESCRIPTION="Small event-driven (SAX-style) JSON parser"
HOMEPAGE="http://lloyd.github.com/yajl/"
SRC_URI="http://github.com/lloyd/yajl/tarball/${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"

IUSE=""

PATCHES=(
	"${FILESDIR}"/${PN}-fix_static_linking.patch
)

src_unpack() {
	unpack ${A}

	cd "${WORKDIR}"/lloyd-${PN}-*
	S=$(pwd)
}

src_test() {
	pushd "${CMAKE_BUILD_DIR}" > /dev/null
	emake test
	popd > /dev/null
}
