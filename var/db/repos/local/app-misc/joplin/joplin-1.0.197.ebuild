# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=" n open source note taking and to-do application"
HOMEPAGE="https://joplinapp.org/
	https://github.com/laurent22/joplin"
SRC_URI="https://github.com/laurent22/joplin/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	x11-libs/gtk+:3
	media-libs/libexif
	gnome-extra/libgsf
	media-libs/libjpeg-turbo
	media-libs/libwebp
	dev-lang/orc
	net-libs/nodejs
	dev-libs/nss
	x11-libs/libXScrnSaver
	"
RDEPEND="${DEPEND}"
BDEPEND="net-misc/rsync"

src_prepare() {
	default
	sed -i '/"husky": ".*"/d' "${S}"/package.json

}

src_compile() {
	export LANG=en_US.utf8

	# npm complains for missing execa package - force to install it
	npm install --cache "${S}/npm-cache" execa || die "install execa failed"
	npm install --cache "${S}/npm-cache" || die "install failed"

	# CliClient
	cd "${S}/CliClient"
	npm install --cache "${S}/npm-cache" || die "install CliClient failed"

	# Electron App
	cd "${S}/ElectronClient"
	npm install --cache "${S}/npm-cache" || die "install ElectronClient failed"
	npm run dist || die "dist failed"
}

src_install() {
	echo "install test"
}
