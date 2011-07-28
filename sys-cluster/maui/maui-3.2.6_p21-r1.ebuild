# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/maui/maui-3.2.6_p21-r1.ebuild,v 1.1 2010/03/24 22:30:13 jsbronder Exp $

inherit autotools eutils multilib

DESCRIPTION="Maui Cluster Scheduler"
HOMEPAGE="http://www.clusterresources.com/products/maui/"
SRC_URI="http://www.clusterresources.com/downloads/maui/${P/_/}.tar.gz"
IUSE=""
DEPEND="sys-cluster/torque"
RDEPEND="${DEPEND}"
SLOT="0"
LICENSE="maui"
KEYWORDS="~x86 ~amd64"
RESTRICT="fetch mirror"

S="${WORKDIR}/${P/_/}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-autoconf-2.60-compat.patch
	# http://www.supercluster.org/pipermail/mauiusers/2010-March/004174.html
	epatch "${FILESDIR}"/maui-3.2.6_p21-pbs-nodefile.patch
	sed -i \
		-e "s~BUILDROOT=~BUILDROOT=${D}~" \
		"${S}"/Makefile.in
	eautoreconf
}

src_compile() {
	econf --with-spooldir=/usr/spool/maui || die
	emake || die
}

src_install() {
	make install INST_DIR="${D}/usr"
	cd docs
	dodoc README mauidocs.html
}

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}, obtain the file"
	einfo "${P/_/}.tar.gz and put it in ${DISTDIR}"
}
