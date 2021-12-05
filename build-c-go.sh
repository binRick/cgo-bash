#!/usr/bin/bash
set -e
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source .envrc
START_DIR="$(pwd)"
VERSION="${1:-$BUILD_BASH_VERSION}"
[ "$VERSION" == "" ] && echo "build.sh: must specify bash version to download" && exit 1
command -v patch || dnf -y install patch
bashsrc="bash-${VERSION}"
archive="$bashsrc.tar.gz"
shasum="$archive.sha256"

RELEASE_DIR="$(cd ./. && pwd)/RELEASE"
BIN_DIR=$RELEASE_DIR/bin
LIB_DIR=$RELEASE_DIR/lib

[[ -d $BIN_DIR ]] || mkdir -p $BIN_DIR
[[ -d $LIB_DIR ]] || mkdir -p $LIB_DIR



get_c_go_bytes(){
  if [[ ! -f "$START_DIR/c.go" ]]; then echo 0; else
    command cat $START_DIRc.go|command wc -c
  fi
  true
}
















(
	cd "${bashsrc}"

	ldflags="$(make ldflags | tail -1 | sed -E "s%\./%\${SRCDIR}/${bashsrc}/%g")"
	ldflags="$(
		for ldflag in $ldflags; do
			[ "${ldflag:0:1}" == "-" ] && echo -n "$ldflag " || echo -n "\${SRCDIR}/${bashsrc}/${ldflag} "
		done
	)"

	#  if [[ ! -f "$START_DIR/c.go" ]]; then
	cat <<EOF >$START_DIR/c.go
      package bash

      // #cgo LDFLAGS: ${ldflags}
      import "C"
EOF
	gofmt -w $START_DIR/c.go
	#  fi
)

# always rebuild because Go doesn't know if C files/libraries have changed
exit 0
#go install -a -v
