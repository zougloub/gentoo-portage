# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/psutil/psutil-0.2.1.ebuild,v 1.2 2011/07/26 16:08:51 neurogeek Exp $

EAPI="3"
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
PYTHON_TESTS_RESTRICTED_ABIS="3.*"

inherit distutils

DESCRIPTION="Retrieve information on running processes and system utilization"
HOMEPAGE="http://code.google.com/p/psutil/ http://pypi.python.org/pypi/psutil"
SRC_URI="http://psutil.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# A few tests are broken
RESTRICT="test"

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" test/test_psutil.py
	}
	python_execute_function testing
}
