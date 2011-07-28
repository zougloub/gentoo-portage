# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/stardict-hnd-vi-vi/stardict-hnd-vi-vi-20050917.ebuild,v 1.4 2009/01/23 13:27:02 pva Exp $

FROM_LANG="Vietnamese"
TO_LANG="Vietnamese"

inherit stardict

HOMEPAGE="http://forum.vnoss.org/viewtopic.php?id=1818"
SRC_URI="http://james.dyndns.ws/pub/Dictionary/StarDict-James/VietViet30K.zip"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}/VietViet
