# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PhpDocumentor/PEAR-PhpDocumentor-1.4.3.ebuild,v 1.1 2009/09/23 03:06:57 beandog Exp $

inherit php-pear-r1

DESCRIPTION="The phpDocumentor package provides automatic documenting of php api directly from the source."
# see http://pear.php.net/bugs/bug.php?id=12577 for additional info on licensing mess
LICENSE="PHP-2.02 PHP-3 LGPL-2.1 public-domain Apache-2.0 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( >=dev-php/PEAR-XML_Beautifier-1.1-r1 )"
