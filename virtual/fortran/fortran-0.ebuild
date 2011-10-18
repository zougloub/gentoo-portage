# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/fortran/fortran-0.ebuild,v 1.7 2011/10/17 20:26:04 xarthisius Exp $

EAPI=4

DESCRIPTION="Virtual for Fortran Compiler"
HOMEPAGE=""
SRC_URI=""

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
LICENSE=""
IUSE="openmp"

RDEPEND="
	|| ( sys-devel/gcc[fortran] sys-devel/gcc-apple[fortran]
	dev-lang/ekopath dev-lang/path64 dev-lang/ifc )
	openmp? (
		|| ( sys-devel/gcc[fortran,openmp?] sys-devel/gcc-apple[fortran,openmp?]
		dev-lang/ekopath dev-lang/path64[openmp?] dev-lang/ifc ) )"
DEPEND="${RDEPEND}"
