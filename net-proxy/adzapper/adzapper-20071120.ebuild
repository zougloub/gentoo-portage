# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/adzapper/adzapper-20071120.ebuild,v 1.5 2008/08/08 21:08:50 beandog Exp $

MY_P=${P/zapper/zap}

DESCRIPTION="Redirector for squid that intercepts advertising, page counters and some web bugs"
HOMEPAGE="http://adzapper.sourceforge.net/"
SRC_URI="http://adzapper.sourceforge.net/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

RDEPEND="dev-lang/perl
	net-proxy/squid"

S="${WORKDIR}/adzap"

src_unpack() {
	unpack ${A}

	cd "${S}/scripts" || die "Scripts directory not found"

	# update the zapper path in various scripts
	local f SCRPATH="/etc/adzapper/squid_redirect"
	for f in wrapzap update-zapper*; do
		sed -i -e "s|^zapper=.*|zapper=${SCRPATH}|" \
			-e "s|^ZAPPER=.*|ZAPPER=\"${SCRPATH}\"|" \
			-e "s|^pidfile=.*|pidfile=/var/run/squid.pid|" \
			-e "s|^PIDFILE=.*|PIDFILE=\"/var/run/squid.pid\"|" \
			-e "s|^RESTARTCMD=.*|RESTARTCMD=\"/etc/init.d/squid restart\"|" \
				$f || die "sed updating failed."
	done
}

src_install() {
	cd "${S}/scripts"
	exeinto /etc/adzapper
	doexe wrapzap zapchain squid_redirect

	insinto /etc/adzapper
	doins update-zapper*

	cd "${S}/zaps"
	insinto /var/www/localhost/htdocs/zap
	doins *
}

pkg_postinst() {
	einfo "To enable adzapper, add the following lines to /etc/squid/squid.conf:"
	einfo "    url_rewrite_program /etc/adzapper/wrapzap"
	einfo "    url_rewrite_children 10"
}
