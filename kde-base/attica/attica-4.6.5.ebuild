# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/attica/attica-4.6.5.ebuild,v 1.2 2011/08/09 17:12:21 hwoarang Exp $

EAPI=4

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="Open Collaboration Services provider management"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	>=dev-libs/libattica-0.1.4
"
RDEPEND="${DEPEND}"
