# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/skencil/skencil-0.6.18_pre20080519.ebuild,v 1.11 2011/03/04 23:32:26 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="tk"

inherit eutils multilib python

DESCRIPTION="Interactive X11 vector drawing program"
HOMEPAGE="http://www.skencil.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 sparc x86"
IUSE="nls"

DEPEND=">=dev-python/imaging-1.1.2-r1
	dev-python/pyxml
	dev-python/reportlab
	dev-lang/tk
	nls? ( sys-devel/gettext )"
RDEPEND="${DEPEND}
	!elibc_glibc? ( nls? ( sys-devel/gettext ) )"

S="${WORKDIR}/${PN}-0.6"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/skencil-configure-without-nls.diff"
	epatch "${FILESDIR}/skencil-0.6.17-setup.py.patch"

	# Fix hardcoded libdir
	sed -i -e "s:lib/:$(get_libdir)/:" \
		-e "s:lib':$(get_libdir)':" \
		"${S}"/{Pax,Filter,Sketch/Modules}/Makefile.pre.in \
		"${S}"/Plugins/Objects/Lib/multilinetext/{TextEditor,styletext}.py \
		"${S}"/setup.py || die "sed failed"
}

src_compile() {
	./setup.py configure `use_with nls` || die
	BLDSHARED='gcc -shared' ./setup.py build || die
}

src_install () {
	./setup.py install --prefix=/usr --dest-dir="${D}"
	assert "setup.py install failed"

	newdoc Pax/README README.pax
	newdoc Filter/README README.filter
	dodoc Examples Doc Misc
	dodoc README INSTALL BUGS CREDITS TODO PROJECTS FAQ NEWS
}
