# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ekeyd/ekeyd-1.1.3-r4.ebuild,v 1.2 2011/04/08 11:14:49 flameeyes Exp $

EAPI=4

inherit multilib linux-info toolchain-funcs

DESCRIPTION="Entropy Key userspace daemon"
HOMEPAGE="http://www.entropykey.co.uk/"
SRC_URI="http://www.entropykey.co.uk/res/download/${P}.tar.gz"

LICENSE="as-is" # yes, truly

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="usb kernel_linux munin minimal"

EKEYD_RDEPEND="dev-lang/lua
		usb? ( virtual/libusb:0 )"
EKEYD_DEPEND="${EKEYD_RDEPEND}"
EKEYD_RDEPEND="${EKEYD_RDEPEND}
	dev-lua/luasocket
	kernel_linux? ( sys-fs/udev )
	usb? ( !kernel_linux? ( sys-apps/usbutils ) )
	munin? ( net-analyzer/munin )"

RDEPEND="!minimal? ( ${EKEYD_RDEPEND} )
	!app-crypt/ekey-egd-linux"
DEPEND="!minimal? ( ${EKEYD_DEPEND} )"

CONFIG_CHECK="~USB_ACM"

REQUIRED_USE="minimal? ( !munin !usb )"

pkg_setup() {
	if ! use minimal && use kernel_linux && ! use usb && linux_config_exists; then
		check_extra_config
	fi
}

src_prepare() {
	# - avoid using -Werror;
	sed -i \
		-e 's:-Werror::' \
		daemon/Makefile || die

	epatch "${FILESDIR}"/${PN}-1.1.1-earlyboot.patch
	epatch "${FILESDIR}"/${P}-libusb_compat.patch
	epatch "${FILESDIR}"/${P}-slashes.patch
	epatch "${FILESDIR}"/${P}-format.patch

	# Stupid multilib hack; remove it once Gentoo has sane paths for
	# udev directories.
	if [[ $(get_libdir) != lib ]]; then
		sed -i -e "s:/lib/udev/:/$(get_libdir)/udev/:" \
			doc/*.rules || die
	fi

	# We moved the binaries around
	sed -i -e 's:$BINPATH/ekey-ulusbd:/usr/libexec/ekey-ulusbd:' \
		doc/ekeyd-udev || die
}

src_compile() {
	local osname

	# Override automatic detection: upstream provides this with uname,
	# we don't like using uname.
	case ${CHOST} in
		*-linux-*)
			osname=linux;;
		*-freebsd*)
			osname=freebsd;;
		*-kfrebsd-gnu)
			osname=gnukfreebsd;;
		*-openbsd*)
			osname=openbsd;;
		*)
			die "Unsupported operating system!"
			;;
	esac

	# We don't slot LUA so we don't really need to have the variables
	# set at all.
	emake -C daemon \
		CC="$(tc-getCC)" \
		LUA_V= LUA_INC= \
		OSNAME=${osname} \
		OPT="${CFLAGS}" \
		BUILD_ULUSBD=$(use usb && echo yes || echo no) \
		$(use minimal && echo egd-linux) \
		|| die "emake failed"
}

src_install() {
	exeinto /usr/libexec
	newexe "${S}"/daemon/egd-linux ekey-egd-linux || die
	doman daemon/ekey-egd-linux.8 || die

	newconfd "${FILESDIR}"/ekey-egd-linux.conf ekey-egd-linux || die
	newinitd "${FILESDIR}"/ekey-egd-linux.init ekey-egd-linux || die

	use minimal && return
	# from here on, install everything that is not part of the minimal
	# support.

	emake -C daemon \
		DESTDIR="${D}" \
		BUILD_ULUSBD=$(use usb && echo yes || echo no) \
		MANZCMD=cat MANZEXT= \
		install || die "emake install failed"

	# We move the daemons around to avoid polluting the available
	# commands.
	dodir /usr/libexec
	mv "${D}"/usr/sbin/ekey*d "${D}"/usr/libexec

	newinitd "${FILESDIR}"/${PN}.init ${PN} || die

	if use usb; then
		if ! use kernel_linux; then
			newinitd "${FILESDIR}"/ekey-ulusbd.init ekey-ulusbd || die
			newconfd "${FILESDIR}"/ekey-ulusbd.conf ekey-ulusbd || die
		fi
		doman daemon/ekey-ulusbd.8 || die
	fi

	dodoc daemon/README* AUTHORS WARNING ChangeLog || die

	if use kernel_linux; then
		local rules=doc/60-UDEKEY01.rules
		use usb && rules=doc/60-UDEKEY01-UDS.rules

		insinto /$(get_libdir)/udev/rules.d
		newins ${rules} 70-${PN}.rules || die

		exeinto /$(get_libdir)/udev
		doexe doc/ekeyd-udev || die
	fi

	if use munin; then
		exeinto /usr/libexec/munin/plugins
		doexe munin/ekeyd_stat_

		insinto /etc/munin/plugin-conf.d
		newins munin/plugin-conf.d_ekeyd ekeyd
	fi
}

pkg_postinst() {
	elog "${CATEGORY}/${PN} now install also the EGD client service ekey-egd-linux."
	elog "To use this service, you need enable EGDTCPSocket for the ekeyd service"
	elog "managing the key(s)."
	elog ""
	elog "The daemon will send more entropy to the kernel once the available pool"
	elog "falls below the value set in the kernel.random.write_wakeup_threshold"
	elog "sysctl entry."
	elog ""
	elog "You can change the watermark in /etc/conf.d/ekey-egd-linux; if you do"
	elog "it will require write access to the kernel's sysctl."

	use minimal && return
	# from here on, document everything that is not part of the minimal
	# support.

	elog ""
	elog "To make use of your EntropyKey, make sure to execute ekey-rekey"
	elog "the first time, and then start the ekeyd service."
	elog ""
	elog "By default ekeyd will feed the entropy directly to the kernel's pool;"
	elog "if your system has jumps in load average, you might prefer using the"
	elog "EGD compatibility mode, by enabling EGDTCPSocket for ekeyd and then"
	elog "starting the ekey-egd-linux service."
	elog ""
	elog "The same applies if you intend to provide entropy for multiple hosts"
	elog "over the network. If you want to have the ekey-egd-linux service on"
	elog "other hosts, you can enable the 'minimal' USE flag."
	elog ""
	elog "The service supports multiplexing if you wish to use multiple"
	elog "keys, just symlink /etc/init.d/ekeyd → /etc/init.d/ekeyd.identifier"
	elog "and it'll be looking for /etc/entropykey/identifier.conf"
	elog ""

	if use usb; then
		if use kernel_linux; then
			elog "You're going to use the userland USB daemon, the udev rules"
			elog "will be used accordingly. If you want to use the CDC driver"
			elog "please disable the usb USE flag."
		else
			elog "You're going to use the userland USB daemon, since your OS"
			elog "does not support udev, you should start the ekey-ulusbd"
			elog "service before ekeyd."
		fi

		ewarn "The userland USB daemon has multiple known issues. If you can,"
		ewarn "please consider disabling the 'usb' USE flag and instead use the"
		ewarn "CDC-ACM access method."
	else
		if use kernel_linux; then
			elog "Some versions of Linux have a faulty CDC ACM driver that stops"
			elog "EntropyKey from working properly; please check the compatibility"
			elog "table at http://www.entropykey.co.uk/download/"
		else
			elog "Make sure your operating system supports the CDC ACM driver"
			elog "or otherwise you won't be able to use the EntropyKey."
		fi
		elog ""
		elog "If you're unsure about the working state of the CDC ACM driver"
		elog "enable the usb USE flag and use the userland USB daemon"
	fi
}
