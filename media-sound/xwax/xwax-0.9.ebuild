# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/xwax/xwax-0.9.ebuild,v 1.1 2011/05/07 17:50:00 nixphoeni Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Digital vinyl emulation software"
HOMEPAGE="http://www.xwax.co.uk/"
SRC_URI="http://www.xwax.co.uk/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="alsa jack oss cdda mp3 +fallback"
REQUIRED_USE="|| ( cdda mp3 fallback )
	|| ( alsa jack oss )"

RDEPEND="media-libs/libsdl
	media-libs/sdl-ttf
	media-fonts/dejavu
	alsa? ( media-libs/alsa-lib )
	jack? ( media-sound/jack-audio-connection-kit )
	cdda? ( media-sound/cdparanoia )
	mp3? ( || ( media-sound/mpg123 media-sound/mpg321 ) )
	fallback? ( virtual/ffmpeg )"
DEPEND="${RDEPEND}"

DOCS="README CHANGES"

pkg_setup() {
	ewarn "Please note that XWAX_DECODERS is deprecated in favor of USE flags."
	ewarn "Sorry for the inconvenience."
}

src_prepare() {
	# Remove the forced optimization from 'CFLAGS' and 'LDFLAGS' in
	# the Makefile
	# Also replace VERSION so we don't have to depend on git...
	sed -i -e 's:\(^CFLAGS.*\)-O[0-9]\(.*\):\1\2:' \
		-e 's:\(^LDFLAGS.*\)-O[0-9]\(.*\):\1\2:' \
		-e "s:\(^VERSION =\).*:\1 ${PV}:" \
		Makefile || die "sed failed"

	# Replace any decoder commands in the import script, if necessary
	if [[ `use mp3` ]]; then
		# mpg123 is upstream's default
		if has_version media-sound/mpg123; then
			TO="mpg123"
			FROM="mpg321"
		# Otherwise, use mpg321
		else
			TO="mpg321"
			FROM="mpg123"
		fi
		debug-print "found ${TO}"
		sed -i -e "s:${FROM}:${TO}:g" import || \
			die "problem converting xwax-import to use ${TO}"
	fi
}

src_configure() {
	tc-export CC
	econf \
		--prefix "${EROOT}usr" \
		$(use_enable alsa) \
		$(use_enable jack) \
		$(use_enable oss)
}

src_compile() {
	# EXECDIR is the default directory in which xwax will look for
	# the 'xwax-import' and 'xwax-scan' scripts
	emake EXECDIR="${EROOT}usr/bin"
}

src_install() {
	# This is easier than setting all the environment variables
	# needed, running the sed script required to get the man directory
	# correct, and removing the GPL-2 after a 'make install' run
	dobin xwax || die "failed to install xwax"
	newbin import xwax-import || die "failed to install xwax-import"
	newbin scan xwax-scan || die "failed to install xwax-scan"
	doman xwax.1 || die "failed to install man page"

	dodoc ${DOCS} || die "failed to install docs"
}
