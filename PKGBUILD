# Maintainer: Johannes Löthberg <johannes@kyriasis.com>
# Contributor: Bartłomiej Piotrowski <bpiotrowski@archlinux.org>

pkgname=haproxy
pkgver=3.3.3
pkgrel=2

# Each release serie has its own repository. This is handled automatically in
# PKGBUILD, but nvchecker configuration needs to be updated on bump!

pkgdesc='Reliable, high performance TCP/HTTP load balancer'
url='https://www.haproxy.org/'
arch=('x86_64')
license=('GPL-2.0-or-later')

depends=('openssl' 'pcre2' 'zlib' 'libxcrypt' 'libcrypt.so' 'lua' 'systemd-libs')
makedepends=('git' 'systemd')

backup=('etc/haproxy/haproxy.cfg')

install=haproxy.install

validpgpkeys=('0C9568FA554656551590C5E44E386D9C9C61702F'  # Willy Tarreau <w@1wt.eu>
              '07D5F18D201984D7D13FB7AAF5F936267AA4B280'  # Christopher Faulet <christopher.faulet@capflam.org>
              '692A51FE968BDB627C8C4B0E12F8CCEE5C19FD8D') # Amaury Denoyelle <adenoyelle@haproxy.com>
source=("git+https://git.haproxy.org/git/haproxy-${pkgver%.*}.git#tag=v${pkgver}?signed"
        'haproxy.cfg'
        'haproxy.sysusers'
        '0001-Use-CFLAGS-and-LDFLAGS-when-building-admin.patch')

sha256sums=('9a899b1a3595e69689dc085a5c12707da93b575a3dd4b576b3096dce5e187f91'
            'f6babef513b99a3fa0e50f2b144c73c980f1b78b119874ffa2580af1e651e7a9'
            'c6e716ea59272a8e871af53703726dd2a75b56c82dacf097d4bf08ac5e841a0d'
            'a1e3a1c2923465081383eb431bae55ff9841d89909469311cdba4b394ec4a998')

prepare() {
  cd "haproxy-${pkgver%.*}"

  patch -p1 <"$srcdir"/0001-Use-CFLAGS-and-LDFLAGS-when-building-admin.patch
}

build() {
  cd "haproxy-${pkgver%.*}"

  export CFLAGS="$CFLAGS -fwrapv"

  make \
    CFLAGS="$CFLAGS" \
    LDFLAGS="$LDFLAGS" \
    TARGET=linux-glibc \
    USE_GETADDRINFO=1 \
    USE_LUA=1 \
    USE_OPENSSL=1 \
    USE_PCRE2=1 USE_PCRE2_JIT=1 \
    USE_PROMEX=1 \
    USE_QUIC=1 \
    USE_ZLIB=1

  make \
    SBINDIR=/usr/bin \
    OPTIMIZE= \
    CFLAGS="$CFLAGS" \
    LDFLAGS="$LDFLAGS" \
    admin/{halog/halog,iprange/ip{,6}range}
  make \
    SBINDIR=/usr/bin \
    -C admin/systemd/
}

package() {
  cd "haproxy-${pkgver%.*}"

  make \
    PREFIX="$pkgdir"/usr \
    SBINDIR="$pkgdir"/usr/bin \
    DOCDIR="$pkgdir"/usr/share/$pkgname \
    install

  for admin in admin/{halog/halog,iprange/ip{,6}range}; do
    install -D -m0755 $admin "$pkgdir"/usr/bin/$(basename $admin)
  done

  install -D -m0644 ../haproxy.sysusers "$pkgdir"/usr/lib/sysusers.d/haproxy.conf
  install -D -m0644 ../haproxy.cfg "$pkgdir"/etc/haproxy/haproxy.cfg
  install -D -m0644 admin/systemd/haproxy.service \
    "$pkgdir"/usr/lib/systemd/system/haproxy.service
  install -D -m0644 admin/syntax-highlight/haproxy.vim \
    "$pkgdir"/usr/share/nvim/runtime/syntax/haproxy.vim
  cp -r examples "$pkgdir"/usr/share/haproxy/examples
}
