pkg_name=habitat-hello-world
pkg_origin=wutangfinancial
pkg_version="0.2.5"
pkg_maintainer="Adam Salowitz <asalowi1@ford.com>"
pkg_license=("Apache-2.0")
pkg_deps=(core/bash)
pkg_interpreters=(bin/bash)
pkg_bin_dirs=(bin)

# If your package does NOT download and install a pkg_source you need to override
# build and install functions.  See https://www.habitat.sh/docs/best-practices/#binary-wrapper
do_build() {
  return 0
}

do_install() {
  install -D hello-world.sh "${pkg_prefix}/bin/hello-world.sh"
}
