# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/font-micro-misc/font-micro-misc-1.0.3.ebuild,v 1.8 2011/02/14 13:18:10 xarthisius Exp $

EAPI=3
inherit xorg-2

DESCRIPTION="X.Org micro-misc font"
LICENSE="public-domain"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"
