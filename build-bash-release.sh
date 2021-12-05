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
if [ ! -f "$archive" ]; then
	wget "https://ftp.gnu.org/gnu/bash/$archive"
fi

#shasum -c "$shasum" || exit 1
if [ ! -d "$bashsrc" ]; then
	(
		tar zxf "$archive"
		cd "${bashsrc}"
		for p in ../patches/*.patch; do
			patch -p1 <"$p"
		done
	)
fi

(
	cd "${bashsrc}"
  do_configure(){
    (cd $RELEASE_DIR/../$bashsrc/. && ./configure)
  }
	make static || { do_configure && make -j 5 static; } 
	make strip || { do_configure && make -j 5 strip; } 

	rsync ./libbash.a $LIB_DIR/libbash.a
	rsync ./bash $BIN_DIR/bash

	ldflags=$(make ldflags | tail -1 | sed -E "s%\./%\${SRCDIR}/${bashsrc}/%g")
	ldflags=$(
		for ldflag in $ldflags; do
			[ "${ldflag:0:1}" == "-" ] && echo -n "$ldflag " || echo -n "\${SRCDIR}/${bashsrc}/${ldflag} "
		done
	)

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
