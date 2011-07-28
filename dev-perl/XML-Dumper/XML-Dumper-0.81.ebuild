# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/XML-Dumper/XML-Dumper-0.81.ebuild,v 1.12 2010/02/06 13:46:24 tove Exp $

EAPI=2

MODULE_AUTHOR=MIKEWONG
inherit perl-module

DESCRIPTION="Perl module for dumping Perl objects from/to XML"

SLOT="0"
KEYWORDS="amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND=">=dev-perl/XML-Parser-2.16"
DEPEND="${RDEPEND}"

SRC_TEST="do"
