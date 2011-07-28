# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/a2jmidid/a2jmidid-6.ebuild,v 1.1 2010/01/09 18:49:56 aballier Exp $

inherit toolchain-funcs

DESCRIPTION="Daemon for exposing legacy ALSA sequencer applications in JACK MIDI system."
HOMEPAGE="http://home.gna.org/a2jmidid/"
SRC_URI="http://download.gna.org/a2jmidid/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/alsa-lib
	media-sound/jack-audio-connection-kit
	sys-apps/dbus"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	dev-lang/python"

src_compile() {
	tc-export CC AR CPP LD RANLIB
	./waf configure --prefix=/usr || die "failed to configure"
	./waf || die "failed to build"
}

src_install() {
	./waf --destdir="${D}" install || die "install failed"
	dodoc AUTHORS README NEWS internals.txt
}
