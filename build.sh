#!/bin/bash
set -e

MESOS_VERSION="${MESOS_VERSION:=1.2.0}"
MESOS_PACKAGE="mesos-$MESOS_VERSION.tar.gz"
MESOS_APACHE_BASE_URL="http://www-eu.apache.org/dist/mesos"
MESOS_PACKAGE_URL="$MESOS_APACHE_BASE_URL/$MESOS_VERSION/$MESOS_PACKAGE"
MESOS_KEYS_URL="$MESOS_APACHE_BASE_URL/KEYS"

MESOS_CONFIG_FLAGS="$MESOS_CONFIG_FLAGS"
MESOS_MAKE_FLAGS="$MESOS_MAKE_FLAGS"
MESOS_BUILD_PATH="${MESOS_BUILD_PATH:=/mesos}"

function download_mesos {

  cd $MESOS_BUILD_PATH

  # Check if a tarball already exists for this version
  [ ! -f "$MESOS_BUILD_PATH/$MESOS_PACKAGE" ] && {
    # Check package integrity
    curl -L $MESOS_KEYS_URL -o KEYS
    gpg --import KEYS
    curl -L $MESOS_PACKAGE_URL.asc -o $MESOS_BUILD_PATH/$MESOS_PACKAGE.asc
    curl -L $MESOS_PACKAGE_URL -o $MESOS_BUILD_PATH/$MESOS_PACKAGE
    gpg --verify $MESOS_PACKAGE.asc $MESOS_PACKAGE
  }

  # Check if it was extracted already
  [ ! -d "mesos-$MESOS_VERSION" ] && {
    tar xvf $MESOS_PACKAGE
  }

  echo

}

function build_mesos {

  cd $MESOS_BUILD_PATH/mesos-$MESOS_VERSION

  ./configure $MESOS_CONFIG_FLAGS
  make $MESOS_MAKE_FLAGS

  [ ! -d build ] && {
    mkdir -v build
  }

  make install DESTDIR="$PWD/build"
  make distclean

}

[ $# -gt 0 ] && {
  exec "$@"
}

echo "Building Mesos $MESOS_VERSION"

download_mesos
build_mesos
