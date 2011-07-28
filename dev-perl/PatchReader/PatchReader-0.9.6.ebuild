# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PatchReader/PatchReader-0.9.6.ebuild,v 1.1 2011/05/12 16:03:04 tove Exp $

EAPI=4

MODULE_AUTHOR=TMANNERM
MODULE_VERSION=0.9.6
inherit perl-module

DESCRIPTION="Module for reading diff-compatible patch files"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/perl-File-Temp"
DEPEND="${RDEPEND}"

SRC_TEST=do
