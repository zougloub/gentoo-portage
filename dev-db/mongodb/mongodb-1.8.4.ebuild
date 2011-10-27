# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mongodb/mongodb-1.8.4.ebuild,v 1.1 2011/10/27 07:56:16 ultrabug Exp $

EAPI=4
SCONS_MIN_VERSION="1.2.0"

inherit eutils multilib scons-utils versionator

MY_P=${PN}-src-r${PV/_rc/-rc}

DESCRIPTION="A high-performance, open source, schema-free document-oriented database"
HOMEPAGE="http://www.mongodb.org"
SRC_URI="http://downloads.mongodb.org/src/${MY_P}.tar.gz
	mms-agent? ( https://mms.10gen.com/settings/10gen-mms-agent.zip )"

LICENSE="AGPL-3 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mms-agent static-libs v8"

PDEPEND="mms-agent? ( dev-python/pymongo )"
RDEPEND="!v8? ( =dev-lang/spidermonkey-1.8.2* )
	v8? ( dev-lang/v8 )
	dev-libs/boost
	dev-libs/libpcre[cxx]
	net-libs/libpcap"
DEPEND="${RDEPEND}
	sys-libs/readline
	sys-libs/ncurses"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb

	scons_opts=" --cxx=$(tc-getCXX) --sharedclient"
	if use v8; then
		scons_opts+=" --usev8"
	else
		scons_opts+=" --usesm"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.8-fix-scons.patch"
	epatch "${FILESDIR}/${PN}-linux3.patch"
}

src_compile() {
	escons ${scons_opts} all
}

src_install() {
	escons ${scons_opts} --full --nostrip install --prefix="${D}"/usr

	use static-libs || rm "${D}/usr/$(get_libdir)/libmongoclient.a"

	for x in /var/{lib,log,run}/${PN}; do
		keepdir "${x}"
		fowners mongodb:mongodb "${x}"
	done

	doman debian/mongo*.1
	dodoc README docs/building.md

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN/db/s}.initd" ${PN/db/s}
	newconfd "${FILESDIR}/${PN/db/s}.confd" ${PN/db/s}

	if use mms-agent; then
		local MY_PN="mms-agent"
		local MY_D="/opt/${MY_PN}"
		insinto ${MY_D}
		doins "${WORKDIR}/${MY_PN}/"*
		fowners -R mongodb:mongodb ${MY_D}
		newinitd "${FILESDIR}/${MY_PN}.initd" ${MY_PN}
	fi
}

src_test() {
	escons ${scons_opts} test
	"${S}"/test --dbpath=unittest || die
}

pkg_postinst() {
	if [[ ${REPLACING_VERSIONS} < 1.8 ]]; then
		ewarn "You just upgraded from a previous version of mongodb !"
		ewarn "Make sure you run 'mongod --upgrade' before using this version."
	fi
	elog "Journaling is now enabled by default, see /etc/conf.d/${PN}"
}
