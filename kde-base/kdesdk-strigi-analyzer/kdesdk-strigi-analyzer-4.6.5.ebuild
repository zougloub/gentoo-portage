# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-strigi-analyzer/kdesdk-strigi-analyzer-4.6.5.ebuild,v 1.2 2011/08/09 17:12:23 hwoarang Exp $

EAPI=4

KMNAME="kdesdk"
KMMODULE="strigi-analyzer"
inherit kde4-meta

DESCRIPTION="kdesdk: strigi plugins"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-misc/strigi
"
RDEPEND="${DEPEND}"
