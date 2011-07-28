# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/jack-keyboard/jack-keyboard-2.5.ebuild,v 1.2 2008/07/24 19:00:46 armin76 Exp $

EAPI=1

DESCRIPTION="A virtual MIDI keyboard for JACK MIDI"
HOMEPAGE="http://pin.if.uz.zgora.pl/~trasz/jack-keyboard/"
SRC_URI="http://pin.if.uz.zgora.pl/~trasz/jack-keyboard/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lash X"

RDEPEND=">=media-sound/jack-audio-connection-kit-0.103
	>=x11-libs/gtk+-2.12:2
	>=dev-libs/glib-2.2:2
	lash? ( media-sound/lash )
	X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-apps/sed"

src_compile(){
	econf $(use_with X x11) \
		$(use_with lash)
	emake || die "failed to build"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc NEWS README TODO AUTHORS
}
