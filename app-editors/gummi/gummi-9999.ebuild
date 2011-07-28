# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/gummi/gummi-9999.ebuild,v 1.1 2010/10/24 11:34:37 hwoarang Exp $

EAPI=2
inherit base eutils subversion

ESVN_REPO_URI="http://dev.midnightcoding.org/svn/gummi/trunk"
ESVN_PROJECT="${PN/-svn}"

DESCRIPTION="Simple LaTeX editor for GTK+ users"
HOMEPAGE="http://gummi.midnightcoding.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

LANGS="ca da de fr el it nl pt_BR ru zh_TW"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND=">=dev-libs/glib-2.16:2
	dev-texlive/texlive-latex
	dev-texlive/texlive-latexextra
	>=x11-libs/gtk+-2.16:2"
DEPEND="${RDEPEND}
	app-text/gtkspell
	app-text/poppler[cairo]
	x11-libs/gtksourceview:2.0
	x11-libs/pango"

DOCS=( AUTHORS ChangeLog README )

src_prepare() {
	strip-linguas ${LANGS}
}

pkg_postinst() {
	elog "Gummi >=0.4.8 supports spell-checking through gtkspell. Support for"
	elog "additional languages can be added by installing myspell-** packages"
	elog "for your language of choice."
}
