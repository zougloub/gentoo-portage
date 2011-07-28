# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/graphviz-dot-mode/graphviz-dot-mode-0.3.7.ebuild,v 1.1 2011/04/22 16:18:47 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="Emacs mode for editing and previewing Graphviz dot graphs"
HOMEPAGE="http://users.skynet.be/ppareit/projects/graphviz-dot-mode/graphviz-dot-mode.html
	http://www.graphviz.org/"
# taken from http://users.skynet.be/ppareit/projects/${PN}/${PN}.el
SRC_URI="mirror://gentoo/${P}.el.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
