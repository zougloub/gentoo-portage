# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-zope/zope-copypastemove/zope-copypastemove-3.8.0.ebuild,v 1.1 2010/11/08 13:49:08 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN="${PN/-/.}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Copy, Paste and Move support for content components."
HOMEPAGE="http://pypi.python.org/pypi/zope.copypastemove"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="net-zope/zope-annotation
	net-zope/zope-component
	net-zope/zope-container
	net-zope/zope-copy
	net-zope/zope-event
	net-zope/zope-exceptions
	net-zope/zope-interface
	net-zope/zope-lifecycleevent
	net-zope/zope-location"
DEPEND="${RDEPEND}
	dev-python/setuptools"

S="${WORKDIR}/${MY_P}"

DOCS="CHANGES.txt README.txt"
PYTHON_MODNAME="${PN/-//}"
