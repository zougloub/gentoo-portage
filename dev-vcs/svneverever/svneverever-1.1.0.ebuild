# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/svneverever/svneverever-1.1.0.ebuild,v 1.1 2011/04/03 01:05:06 sping Exp $

EAPI="2"

PYTHON_DEPEND="*:2.6"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.[45]"

inherit distutils

DESCRIPTION="Tool collecting path entries across SVN history"
HOMEPAGE="http://git.goodpoint.de/?p=svneverever.git;a=summary"
SRC_URI="http://www.hartwork.org/public/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-python/pysvn
	|| ( >=dev-lang/python-2.7
	( >=dev-lang/python-2.6 dev-python/argparse ) )"
