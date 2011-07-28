# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/libspectrum/libspectrum-0.2.2-r1.ebuild,v 1.6 2008/05/18 16:31:34 drac Exp $

DESCRIPTION="Spectrum emulation library"
HOMEPAGE="http://www.srcf.ucam.org/~pak21/spectrum/libspectrum.html"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="amd64 ppc x86"

RDEPEND=">=dev-libs/glib-2
	dev-libs/libgcrypt
	dev-lang/perl"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf --with-glib || die
	emake -j1 || die "libspectrum make failed!"
}

src_install() {
	make install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog README THANKS doc/*.txt *.txt
}
