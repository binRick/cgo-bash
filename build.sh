#!/usr/bin/bash
set -e
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source .envrc
START_DIR="$(pwd)"
VERSION="${1:-$BUILD_BASH_VERSION}"

RELEASE_DIR="$(cd ./. && pwd)/RELEASE"
BIN_DIR=$RELEASE_DIR/bin
LIB_DIR=$RELEASE_DIR/lib

[[ -d $BIN_DIR ]] || mkdir -p $BIN_DIR
[[ -d $LIB_DIR ]] || mkdir -p $LIB_DIR

direnv allow .
passh -L .10-build-bash-release.log env ./build-bash-release.sh ${BUILD_BASH_VERSION}
passh -L .20-build-docs.log env ./build-docs.sh
passh -L .30-compile-libbash-shared-object.log env gcc -o ./RELEASE/lib/libbash.so -Wall -g -shared -fPIC -lm bash.c
color black green
echo Built libbash.so
color reset
#passh -L .40-build-c-go-sh.log /bin/bash --norc --noprofile -c "./build-c-go.sh"
./build-c-go.sh
(
  cd $START_DIR/cmd/basic/. 
  LD_LIBRARY_PATH=$START_DIR/RELEASE/lib 
  CGO_ENABLED=1 go build -a -v -o $START_DIR/RELEASE/bin/basic main.go
)

color black blue
ls -altr ./RELEASE/lib/libbash.so
passh -L .40-build-cgo-binary.log bash --norc --noprofile -c "env LD_LIBRARY_PATH=$START_DIR/RELEASE/lib $START_DIR/RELEASE/bin/main" | grep 'Hello from Go'
ls -altr ./RELEASE/bin/basic
color reset
color black yellow
# ./main
color reset
