#!/bin/bash
set -e

MESOS_VERSION="${MESOS_VERSION:=1.2.0}"
MESOS_CONFIG_FLAGS="$MESOS_CONFIG_FLAGS"
MESOS_MAKE_FLAGS="$MESOS_MAKE_FLAGS"
MESOS_SOURCE_PATH="${MESOS_SOURCE_PATH:=/src/mesos}"
MESOS_BUILD_PATH="$MESOS_SOURCE_PATH/build"
MESOS_OUT_PATH="$MESOS_SOURCE_PATH/out"

function build_mesos {

  cd "$MESOS_SOURCE_PATH"
  git checkout $MESOS_VERSION
  VERSION="$(git rev-parse --abbrev-ref HEAD)"

  [ ! -d "$MESOS_BUILD_PATH" ] && {
    mkdir -v "$MESOS_BUILD_PATH"
  }

  ./bootstrap
  cd "$MESOS_BUILD_PATH" 
  ../configure $MESOS_CONFIG_FLAGS
  make $MESOS_MAKE_FLAGS

  [ ! -d "$MESOS_OUT_PATH" ] && {
    mkdir -v "$MESOS_OUT_PATH"
  }

  make install DESTDIR=$MESOS_OUT_PATH
  make distclean

}

[ $# -gt 0 ] && {
  exec "$@"
}

build_mesos
