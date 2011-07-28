# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/pmtools/pmtools-20071116.ebuild,v 1.7 2009/09/23 20:57:57 patrick Exp $

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="ACPI disassembler tools, including acpidump"
HOMEPAGE="http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/"
SRC_URI="http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl
	>=sys-power/iasl-20060512"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-20071116-acpixtract-pmtools.patch

	sed -i.orig -e '/^CFLAGS/s, -s , ,' \
		-i.orig -e "s:-Os::g" \
		acpidump/Makefile || die "sed failed"

	strip-unsupported-flags
}

src_compile() {
	# respect user's LDFLAGS
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}" || die "emake failed"
}

src_install() {
	# acpidump access the ACPI data via /dev/mem or EFI firmware in /sys
	dosbin acpidump/acpidump
	# the other tools only process data
	newbin acpixtract/acpixtract acpixtract-pmtools
	dobin madt/madt

	dodoc README
	docinto madt
	dodoc madt/README madt/example.APIC*
}

pkg_postinst() {
	ewarn "Please note that acpixtract is now named acpixtract-pmtools to avoid"
	ewarn "conflicts with the new tool of the same name from the iasl package."
}
