# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/tt-rss/tt-rss-1.5.5.ebuild,v 1.2 2011/11/02 21:43:18 vapier Exp $

EAPI="2"

inherit eutils webapp depend.php depend.apache

DESCRIPTION="Tiny Tiny RSS - A web-based news feed (RSS/Atom) aggregator using AJAX"
HOMEPAGE="http://tt-rss.org/"
SRC_URI="http://tt-rss.org/download/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="daemon mysql postgres"

DEPEND="dev-lang/php[mysql?,postgres?]"
RDEPEND="${DEPEND}"

need_httpd_cgi
need_php_httpd
use daemon && need_php_cli

pkg_setup() {
	webapp_pkg_setup
	use mysql && require_php_with_use mysql
	use postgres && require_php_with_use postgres
	if use daemon; then
		require_php_with_use pcntl
		enewgroup ttrssd
		enewuser ttrssd -1 /bin/sh /dev/null ttrssd
	fi
}

src_prepare() {
	# Customize config.php so that the right 'DB_TYPE' is already set (according to the USE flag)
	einfo "Customizing config.php..."
	mv config.php{-dist,} || die "Could not rename config.php-dist to config.php."
	if use mysql && ! use postgres; then
		sed -e "/define('DB_TYPE',/{s:pgsql:mysql:}" -i config.php || die "sed failed"
	fi
	sed -e "/define('DB_TYPE',/{s:// \(or mysql\):// pgsql \1:}" -i config.php \
		|| die "sed failed"
}

src_install() {
	webapp_src_preinst

	insinto "/${MY_HTDOCSDIR}"
	doins -r * || die "Could not copy the files to ${MY_HTDOCSDIR}."
	keepdir "/${MY_HTDOCSDIR}"/icons

	insinto /etc/logrotate.d/
	newins "${FILESDIR}"/ttrssd.logrotated ttrssd || die "Installing ttrssd logrotate config failed."

	for DIR in cache cache/htmlpurifier cache/magpie cache/simplepie lock icons; do
		webapp_serverowned "${MY_HTDOCSDIR}/${DIR}"
	done
	webapp_configfile "${MY_HTDOCSDIR}"/config.php
	if use daemon; then
		webapp_postinst_txt en "${FILESDIR}"/postinstall-en-with-daemon.txt
		newinitd "${FILESDIR}"/ttrssd.initd ttrssd
		newconfd "${FILESDIR}"/ttrssd.confd ttrssd
	else
		webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	fi

	webapp_src_install
}
