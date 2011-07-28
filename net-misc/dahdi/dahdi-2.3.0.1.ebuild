# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dahdi/dahdi-2.3.0.1.ebuild,v 1.2 2011/01/19 16:54:16 chainsaw Exp $

EAPI=3

inherit base linux-mod eutils flag-o-matic

MY_P="${P/dahdi/dahdi-linux}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Kernel modules for Digium compatible hardware (formerly known as Zaptel)."
HOMEPAGE="http://www.asterisk.org"
SRC_URI="http://downloads.asterisk.org/pub/telephony/dahdi-linux/releases/${MY_P}.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fwload-vpmadt032-1.20.0.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-064-1.05.01.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-oct6114-128-1.05.01.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-tc400m-MR6.12.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fwload-vpmadt032-1.20.0.tar.gz
http://downloads.digium.com/pub/telephony/firmware/releases/dahdi-fw-hx8-2.06.tar.gz
mirror://gentoo/gentoo-dahdi-patchset-0.3.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

DEPEND=""
RDEPEND=""

EPATCH_SUFFIX="diff"
PATCHES=( "${WORKDIR}/dahdi-patchset" )

src_unpack() {
	unpack ${A}
	# Copy the firmware tarballs over, the makefile will try and download them otherwise
	for file in ${A} ; do
		cp "${DISTDIR}"/${file} "${MY_P}"/drivers/dahdi/firmware/
	done
	# But without the .bin's it'll still fall over and die, so copy those too.
	cp *.bin "${MY_P}"/drivers/dahdi/firmware/
}

src_compile() {
	unset ARCH
	emake KSRC="${KERNEL_DIR}" DESTDIR="${D}" all || die "Compilation failed"
}

src_install() {
	# setup directory structure so udev rules get installed
	mkdir -p "${D}"/etc/udev/rules.d

	einfo "Installing kernel module"
	emake KSRC="${KERNEL_DIR}" DESTDIR="${D}" install || die "Installation failed"
	rm -rf "$D"/lib/modules/*/modules.*
}
