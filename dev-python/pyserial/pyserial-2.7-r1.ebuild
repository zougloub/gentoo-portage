# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyserial/pyserial-2.7-r1.ebuild,v 1.13 2015/01/02 12:25:24 ago Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Python Serial Port Extension"
HOMEPAGE="http://pyserial.sourceforge.net/ http://sourceforge.net/projects/pyserial/ http://pypi.python.org/pypi/pyserial"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="doc examples"

DEPEND="
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"
RDEPEND=""
PATCHES=( "${FILESDIR}"/mapping.patch )
DOCS=( CHANGES.txt README.txt )

python_prepare_all() {
	# Usual avoid d'loading un-needed objects.inv file
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C documentation html
}

python_install_all() {
	use doc && local HTML_DOCS=( documentation/_build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
