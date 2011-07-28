# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/gish-demo/gish-demo-1.0.0.ebuild,v 1.14 2009/03/09 17:03:52 mr_bones_ Exp $

inherit eutils multilib games

DESCRIPTION="play as an amorphous ball of tar that rolls and squishes around"
HOMEPAGE="http://www.chroniclogic.com/gish.htm"
SRC_URI="ftp://demos.garagegames.com/gish/gishdemo-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 x86"
IUSE=""
RESTRICT="strip"
QA_EXECSTACK="${GAMES_PREFIX_OPT:1}/${PN}/gish"

RDEPEND="media-libs/libsdl
	>=media-libs/openal-1.6.372
	media-libs/freealut
	virtual/opengl
	media-libs/libvorbis
	amd64? (
		app-emulation/emul-linux-x86-xlibs
		app-emulation/emul-linux-x86-sdl
	)"

S=${WORKDIR}/gishdemo

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins -r * || die "doins failed"
	fperms +x "${dir}"/gish
	games_make_wrapper gish ./gish-wrapper "${dir}"

	# looks like when they built the game they accidently
	# linked it against openssl ... lets fake it
	use amd64 && multilib_toolchain_setup x86
	dosym /$(get_libdir)/libc.so.6 "${dir}"/libssl.so.4
	dosym /$(get_libdir)/libc.so.6 "${dir}"/libcrypto.so.4

	# it wants libopenal.so.0 but seems to work with libopenal.so.1
	# (tested with media-libs/openal-1.6.372)
	dosym /usr/$(get_libdir)/libopenal.so.1 "${dir}"/libopenal.so.0

	exeinto "${dir}"
	doexe "${FILESDIR}"/gish-wrapper || die "doexe failed"

	prepgamesdirs
}
