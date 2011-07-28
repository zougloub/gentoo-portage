# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/htmlentities/htmlentities-4.3.0.ebuild,v 1.1 2011/04/10 06:34:25 graaff Exp $

EAPI=2

USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="History.txt"

inherit ruby-fakegem

DESCRIPTION="A simple library for encoding/decoding entities in (X)HTML documents."
HOMEPAGE="http://htmlentities.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-macos"
IUSE=""

ruby_add_bdepend "test? ( virtual/ruby-test-unit )"

each_ruby_test() {
	${RUBY} -Ilib:. -S testrb test/*_test.rb || die "tests failed"
}
