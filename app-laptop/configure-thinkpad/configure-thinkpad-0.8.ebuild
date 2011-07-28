# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-laptop/configure-thinkpad/configure-thinkpad-0.8.ebuild,v 1.2 2010/01/01 20:53:33 ssuominen Exp $

EAPI=2
inherit gnome2

DESCRIPTION="Thinkpad GNOME configuration utility for tpctl"
HOMEPAGE="http://tpctl.sourceforge.net/configure-thinkpad.html"
SRC_URI="mirror://sourceforge/tpctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE=""

RDEPEND=">=app-laptop/tpctl-4.16
	>=x11-libs/gtk+-2.2:2
	>=gnome-base/libgnomeui-2.4
	>=sys-devel/gettext-0.11"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
