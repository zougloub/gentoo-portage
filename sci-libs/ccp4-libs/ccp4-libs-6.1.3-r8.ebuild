# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ccp4-libs/ccp4-libs-6.1.3-r8.ebuild,v 1.5 2011/07/16 12:21:05 jlec Exp $

EAPI=3

inherit eutils fortran-2 gnuconfig multilib toolchain-funcs

SRC="ftp://ftp.ccp4.ac.uk/ccp4"

#UPDATE="04_03_09"
#PATCHDATE="090511"

MY_P="${P/-libs}"

PATCH_TOT="0"

DESCRIPTION="Protein X-ray crystallography toolkit - Libraries"
HOMEPAGE="http://www.ccp4.ac.uk/"
SRC_URI="${SRC}/${PV}/${MY_P}-core-src.tar.gz"
# patch tarball from upstream
	[[ -n ${UPDATE} ]] && SRC_URI="${SRC_URI} ${SRC}/${PV}/updates/${P}-src-patch-${UPDATE}.tar.gz"
# patches created by us
	[[ -n ${PATCHDATE} ]] && SRC_URI="${SRC_URI} http://dev.gentooexperimental.org/~jlec/science-dist/${PV}-${PATCHDATE}-updates.patch.bz2"

for i in $(seq $PATCH_TOT); do
	NAME="PATCH${i}[1]"
	SRC_URI="${SRC_URI}
		${SRC}/${PV}/patches/${!NAME}"
done

LICENSE="ccp4"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	!<sci-chemistry/ccp4-6.1.3
	!<sci-chemistry/ccp4-apps-${PVR}
	!sci-libs/ssm
	app-shells/tcsh
	dev-lang/tcl
	sci-libs/cbflib
	sci-libs/fftw:2.1
	sci-libs/mmdb
	sci-libs/monomer-db
	virtual/fortran
	virtual/jpeg
	virtual/lapack
	virtual/blas"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	einfo "Applying upstream patches ..."
	for patch in $(seq $PATCH_TOT); do
		base="PATCH${patch}"
		dir=$(eval echo \${${base}[0]})
		p=$(eval echo \${${base}[1]})
		pushd "${dir}" >& /dev/null
		ccp_patch "${DISTDIR}/${p}"
		popd >& /dev/null
	done
	einfo "Done."
	echo

	[[ -n ${PATCHDATE} ]] && epatch "${WORKDIR}"/${PV}-${PATCHDATE}-updates.patch

	einfo "Applying Gentoo patches ..."
	# fix buffer overflows wrt bug 339706
	ccp_patch "${FILESDIR}"/${PV}-overflows.patch

	# it tries to create libdir, bindir etc on live system in configure
	ccp_patch "${FILESDIR}"/${PV}-dont-make-dirs-in-configure.patch

	# gerror_ gets defined twice on ppc if you're using gfortran/g95
	ccp_patch "${FILESDIR}"/6.0.2-ppc-double-define-gerror.patch

	# make creation of libccif.so smooth
	ccp_patch "${FILESDIR}"/${PV}-ccif-shared.patch

	# lets try to build libmmdb seperatly
	ccp_patch "${FILESDIR}"/${PV}-dont-build-mmdb.patch

	# unbundle libjpeg and cbflib
	ccp_patch "${FILESDIR}"/${PV}-unbundle-libs.patch

	# Fix missing DESTIDR
	# not installing during build
	ccp_patch "${FILESDIR}"/${PV}-noinstall.patch
	sed \
		-e '/SHARE_INST/s:$(libdir):$(DESTDIR)/$(libdir):g' \
		-i configure || die

	# Fix upstreams code
	ccp_patch "${FILESDIR}"/${PV}-impl-dec.patch

	einfo "Done." # done applying Gentoo patches
	echo

	sed \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-e 's:-Wl,-rpath,$CLIB::g' \
		-e 's: -rpath $CLIB::g' \
		-e 's: -I${srcdir}/include/cpp_c_headers::g' \
		-e 's:sleep 1:sleep .2:g' \
		-i configure || die

	gnuconfig_update
}

src_configure() {
	rm -rf lib/DiffractionImage/{jpg,CBFlib} || die

	# Build system is broken if we set LDFLAGS
	userldflags="${LDFLAGS}"
	export SHARED_LIB_FLAGS="${LDFLAGS}"
	unset LDFLAGS

	# GENTOO_OSNAME can be one of:
	# irix irix64 sunos sunos64 aix hpux osf1 linux freebsd
	# linux_compaq_compilers linux_intel_compilers generic Darwin
	# ia64_linux_intel Darwin_ibm_compilers linux_ibm_compilers
	if [[ "$(tc-getFC)" = "ifort" ]]; then
		if use ia64; then
			GENTOO_OSNAME="ia64_linux_intel"
		else
			# Should be valid for x86, maybe amd64
			GENTOO_OSNAME="linux_intel_compilers"
		fi
	else
		# Should be valid for x86 and amd64, at least
		GENTOO_OSNAME="linux"
	fi

	# Sets up env
	ln -s \
		ccp4.setup-bash \
		"${S}"/include/ccp4.setup

	# We agree to the license by emerging this, set in LICENSE
	sed -i \
		-e "s~^\(^agreed=\).*~\1yes~g" \
		"${S}"/configure

	# Fix up variables -- need to reset CCP4_MASTER at install-time
	sed -i \
		-e "s~^\(setenv CCP4_MASTER.*\)/.*~\1${WORKDIR}~g" \
		-e "s~^\(export CCP4_MASTER.*\)/.*~\1${WORKDIR}~g" \
		-e "s~^\(.*export CBIN=.*\)\$CCP4.*~\1\$CCP4/libexec/ccp4/bin/~g" \
		-e "s~^\(.*setenv CBIN .*\)\$CCP4.*~\1\$CCP4/libexec/ccp4/bin/~g" \
		-e "s~^\(setenv CCP4I_TCLTK.*\)/usr/local/bin~\1${EPREFIX}/usr/bin~g" \
		"${S}"/include/ccp4.setup*

	# Set up variables for build
	source "${S}"/include/ccp4.setup-sh

	export CC=$(tc-getCC)
	export CXX=$(tc-getCXX)
	export COPTIM=${CFLAGS}
	export CXXOPTIM=${CXXFLAGS}
	# Default to -O2 if FFLAGS is unset
	export FC=$(tc-getFC)
	export FOPTIM=${FFLAGS:- -O2}

	export SHARE_LIB="\
		$(tc-getCC) ${userldflags} -shared -Wl,-soname,libccp4c.so -o libccp4c.so \${CORELIBOBJS} \${CGENERALOBJS} \${CUCOBJS} \${CMTZOBJS} \${CMAPOBJS} \${CSYMOBJS} -L../ccif/ -lccif $(gcc-config -L | awk -F: '{for(i=1; i<=NF; i++) printf " -L%s", $i}') -lm && \
		$(tc-getFC) ${userldflags} -shared -Wl,-soname,libccp4f.so -o libccp4f.so \${FORTRANLOBJS} \${FINTERFACEOBJS} -L../ccif/ -lccif -L. -lccp4c -lmmdb $(gcc-config -L | awk -F: '{for(i=1; i<=NF; i++) printf " -L%s", $i}') -lstdc++ -lgfortran -lm"

	# Can't use econf, configure rejects unknown options like --prefix
	./configure \
		--onlylibs \
		--with-shared-libs \
		--with-fftw="${EPREFIX}/usr" \
		--with-warnings \
		--disable-cctbx \
		--disable-clipper \
		--tmpdir="${TMPDIR}" \
		--bindir="${EPREFIX}/usr/libexec/ccp4/bin/" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		${GENTOO_OSNAME} || die "econf failed"
}

src_compile() {
	emake -j1 \
		DESTDIR="${D}" onlylib || die "emake failed"
}

src_install() {
	# Set up variables for build
	source "${S}"/include/ccp4.setup-sh

	emake -j1 \
		DESTDIR="${D}" \
		includedir="${EPREFIX}/usr/include" \
		library_includedir="${EPREFIX}/usr/include" \
		install || die

	sed \
		-e "330,1000d" \
		-i "${S}"/include/ccp4.setup-sh || die

	sed \
		-e "378,1000d" \
		-i "${S}"/include/ccp4.setup-csh || die

	sed \
		-e "s:-${PV/-r*/}::g" \
		-e "s:^\(.*export CCP4_MASTER=\).*:\1${EPREFIX}/usr:g" \
		-e "s:^\(.*setenv CCP4_MASTER\).*:\1 ${EPREFIX}/usr:g" \
		-e "s:^\(.*export CCP4=\).*CCP4_MASTER.*:\1${EPREFIX}/usr:g" \
		-e "s:^\(.*setenv CCP4\).*CCP4_MASTER.*:\1 ${EPREFIX}/usr:g" \
		-e "s:^\(.*export CCP4_SCR=\).*:\1${EPREFIX}/tmp:g" \
		-e "s:^\(.*setenv CCP4_SCR \).*:\1${EPREFIX}/tmp:g" \
		-e "s:^\(.*export BINSORT_SCR=\).*:\1${EPREFIX}/tmp:g" \
		-e "s:^\(.*setenv BINSORT_SCR \).*:\1${EPREFIX}/tmp:g" \
		-e "s:^\(.*export CCP4I_TOP=\).*:\1${EPREFIX}/usr/$(get_libdir)/ccp4/ccp4i:g" \
		-e "s:^\(.*setenv CCP4I_TOP \).*:\1${EPREFIX}/usr/$(get_libdir)/ccp4/ccp4i:g" \
		-e "s:^\(.*export CCP4I_TCLTK=\).*:\1${EPREFIX}/usr/bin:g" \
		-e "s:^\(.*setenv CCP4I_TCLTK \).*:\1${EPREFIX}/usr/bin:g" \
		-e "s:^\(.*export CCP4I_HELP=\).*:\1${EPREFIX}/usr/$(get_libdir)/ccp4/ccp4i/help:g" \
		-e "s:^\(.*setenv CCP4I_HELP \).*:\1${EPREFIX}/usr/$(get_libdir)/ccp4/ccp4i/help:g" \
		-e "s:^\(.*export CBIN=\).*:\1${EPREFIX}/usr/libexec/ccp4/bin:g" \
		-e "s:^\(.*setenv CBIN \).*:\1${EPREFIX}/usr/libexec/ccp4/bin:g" \
		-e "s:^\(.*export CCP4_BIN=\).*:\1${EPREFIX}/usr/libexec/ccp4/bin:g" \
		-e "s:^\(.*setenv CCP4_BIN \).*:\1${EPREFIX}/usr/libexec/ccp4/bin:g" \
		-e "s:^\(.*export CLIBD_MON=\).*:\1${EPREFIX}/usr/share/ccp4/data/monomers/:g" \
		-e "s:^\(.*setenv CLIBD_MON \).*:\1${EPREFIX}/usr/share/ccp4/data/monomers/:g" \
		-e "s:^\(.*export CLIBD=\).*:\1${EPREFIX}/usr/share/ccp4/data:g" \
		-e "s:^\(.*setenv CLIBD \).*:\1${EPREFIX}/usr/share/ccp4/data:g" \
		-e "s:^\(.*export CLIBS=\).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:^\(.*setenv CLIBS \).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:^\(.*export CLIB=\).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:^\(.*setenv CLIB \).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:^\(.*export CCP4_LIB=\).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:^\(.*setenv CCP4_LIB \).*:\1${EPREFIX}/usr/$(get_libdir):g" \
		-e "s:^\(.*export CCP4_BROWSER=\).*:\1firefox:g" \
		-e "s:^\(.*setenv CCP4_BROWSER \).*:\1firefox:g" \
		-e "s:^\(.*export MANPATH=\).*:\1\${MANPATH}:g" \
		-e "s:^\(.*setenv MANPATH \).*:\1\${MANPATH}:g" \
		-e "s:^\(.*export DBCCP4I_TOP=\).*:\1${EPREFIX}/usr/share/ccp4/dbccp4i:g" \
		-e "s:^\(.*setenv DBCCP4I_TOP \).*:\1${EPREFIX}/usr/share/ccp4/dbccp4i:g" \
		-e "s:^\(.*export MOLREPLIB=\).*:\1${EPREFIX}/usr/share/ccp4/data/monomers/:g" \
		-e "s:^\(.*setenv MOLREPLIB \).*:\1${EPREFIX}/usr/share/ccp4/data/monomers/:g" \
		-e "s:^\(.*export CDOC=\).*:\1${EPREFIX}/usr/share/doc:g" \
		-e "s:^\(.*setenv CDOC \).*:\1${EPREFIX}/usr/share/doc:g" \
		-e "s:^\(.*export CEXAM=\).*:\1${EPREFIX}/usr/share/doc/examples:g" \
		-e "s:^\(.*setenv CEXAM \).*:\1${EPREFIX}/usr/share/doc/examples:g" \
		-e "s:^\(.*export CINCL=\).*:\1${EPREFIX}/usr/share/ccp4/include:g" \
		-e "s:^\(.*setenv CINCL \).*:\1${EPREFIX}/usr/share/ccp4/include:g" \
		-e '/# .*LD_LIBRARY_PATH specifies/,/^$/d' \
		-e "/CCP4_HELPDIR/d" \
		-e "/IMOSFLM_VERSION/d" \
		-i "${S}"/include/ccp4.setup* || die

	# Don't check for updates on every sourcing of /etc/profile
	sed -i \
		-e "s:\(eval python.*\):#\1:g" \
		"${S}"/include/ccp4.setup* || die

	# Libs
	for file in "${S}"/lib/*; do
		if [[ -d ${file} ]]; then
			continue
		elif [[ -x ${file} ]]; then
			dolib.so ${file} || die
		else
			insinto /usr/$(get_libdir)
			doins ${file} || die
		fi
	done

	sed \
		-e 's:test "LD_LIBRARY_PATH":test "$LD_LIBRARY_PATH":g' \
		-i "${S}"/include/ccp4.setup-sh || die

	# Setup scripts
	insinto /etc/profile.d
	newins "${S}"/include/ccp4.setup-csh 40ccp4.setup.csh || die
	newins "${S}"/include/ccp4.setup-sh 40ccp4.setup.sh || die
	rm -f "${S}"/include/ccp4.setup*

	# Fix libdir in all *.la files
	sed -i \
		-e "s:^\(libdir=\).*:\1\'${EPREFIX}/usr/$(get_libdir)\':g" \
		"${ED}"/usr/$(get_libdir)/*.la || die

	# Data
	insinto /usr/share/ccp4/data/
	doins -r "${S}"/lib/data/{*.PARM,*.prt,*.lib,*.dic,*.idl,*.cif,*.resource,*.york,*.hist,fraglib,reference_structures} || die

	# Environment files, setup scripts, etc.
	rm -rf "${S}"/include/{ccp4.setup*,COPYING,cpp_c_headers} || die
	insinto /usr/share/ccp4/
	doins -r "${S}"/include || die

	dodoc "${S}"/lib/data/*.doc || die
	newdoc "${S}"/lib/data/README DATA-README || die
}

pkg_postinst() {
	einfo "The Web browser defaults to firefox. Change CCP4_BROWSER"
	einfo "in ${EPREFIX}/etc/profile.d/40ccp4.setup* to modify this."
}

# Epatch wrapper for bulk patching
ccp_patch() {
	EPATCH_SINGLE_MSG="  ${1##*/} ..." epatch ${1}
}
