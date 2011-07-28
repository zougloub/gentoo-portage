# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/pycifrw/pycifrw-3.3-r1.ebuild,v 1.2 2010/10/10 18:29:29 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_PN="PyCifRW"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Provides support for reading and writing of CIF using python"
HOMEPAGE="http://pycifrw.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${MY_P}.tar.gz"

LICENSE="ASRP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="CifFile.py StarFile.py yapps3_compiled_rt.py YappsStarParser_1_0.py YappsStarParser_1_1.py YappsStarParser_DDLm.py"
