# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IPC-Run/IPC-Run-0.900.0.ebuild,v 1.1 2011/07/06 13:22:37 tove Exp $

EAPI=4

MODULE_AUTHOR=TODDR
MODULE_VERSION=0.90
inherit perl-module

DESCRIPTION="system() and background procs w/ piping, redirs, ptys"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

RDEPEND=">=dev-perl/IO-Tty-1.08"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do
