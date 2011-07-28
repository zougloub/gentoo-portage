# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/magit/magit-1.0.0.ebuild,v 1.1 2011/04/17 15:32:04 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="An Emacs mode for GIT"
HOMEPAGE="http://philjackson.github.com/magit/"
SRC_URI="http://github.com/downloads/philjackson/magit/${P}.tar.gz"

LICENSE="GPL-3 FDL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SITEFILE="50magit-gentoo.el"

src_compile() {
	default
}

src_install() {
	elisp-install ${PN} magit{,-svn,-topgit,-key-mode}.{el,elc} || die
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	doinfo magit.info
	dodoc README.md
}
