# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdvdread/libdvdread-9999.ebuild,v 1.2 2009/03/09 18:55:16 beandog Exp $

EAPI="2"
WANT_AUTOCONF="2.5"

inherit eutils autotools multilib subversion

DESCRIPTION="Library for DVD navigation tools"
HOMEPAGE="http://mplayerhq.hu/ http://svn.mplayerhq.hu/dvdnav/trunk/libdvdread/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+css"

ESVN_REPO_URI="svn://svn.mplayerhq.hu/dvdnav/trunk/libdvdread"
ESVN_PROJECT="libdvdread"

src_unpack() {
	subversion_src_unpack
	cd "${S}"
	elibtoolize
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install died"
	dodoc AUTHORS DEVELOPMENT-POLICY.txt ChangeLog TODO README
}
