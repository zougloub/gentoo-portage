# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-SSLeay/Crypt-SSLeay-0.58.ebuild,v 1.1 2010/08/26 16:28:41 tove Exp $

EAPI=3

MODULE_AUTHOR=NANIS
inherit perl-module

DESCRIPTION="Crypt::SSLeay module for perl"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

# Disabling tests for now. Opening a port always leads to mixed results for
# folks - bug 59554
# nb. Re-enabled tests, seem to be better written now, keeping an eye on bugs
# for this though.
SRC_TEST="do"

DEPEND=">=dev-libs/openssl-0.9.7c
	virtual/perl-MIME-Base64"
# PDEPEND: circular dependencies bug #144761
PDEPEND="dev-perl/libwww-perl"

export OPTIMIZE="${CFLAGS}"
myconf="--lib=${EPREFIX}/usr"
