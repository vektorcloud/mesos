#!/bin/bash

ARG=$1
MESOS_STABLE=1.0.1
MESOS_BRANCH="${ARG:=$MESOS_STABLE}"
DOCKER_TAG=$MESOS_BRANCH

git submodule sync && \
  git submodule update --init && \
  cd mesos-src && \
  git checkout "$MESOS_BRANCH" && \
  cd ..
docker build -t "mesos-base:$MESOS_BRANCH" .
docker run -ti -v $PWD:/target "mesos-base:$MESOS_BRANCH" cp -Rvf /mesos-tiny /target/
docker build -f Dockerfile_tiny -t "quay.io/vektorcloud/mesos:$MESOS_BRANCH" .

if [ "$MESOS_BRANCH" == "$MESOS_STABLE" ] ; then
  docker tag "quay.io/vektorcloud/mesos:$MESOS_BRANCH" quay.io/vektorcloud/mesos:latest
fi
