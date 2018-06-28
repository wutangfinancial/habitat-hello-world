pkg_name=habitat-hello-world
pkg_origin=asalowi1
pkg_version="0.1.0"
pkg_maintainer="Adam Salowitz <asalowi1@ford.com>"
pkg_license=("Apache-2.0")
# If your package does NOT download and install a pkg_source you need to override
# build and install functions.  See https://www.habitat.sh/docs/best-practices/#binary-wrapper
do_build() {
  return 0
}

do_install() {
  chmod +x $pkg_prefix/hello.sh
  $pkg_prefix/bin/hello.sh
}
