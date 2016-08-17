# Tiny Mesos

[![Circle CI](https://circleci.com/gh/vektorcloud/mesos.svg?style=svg)](https://circleci.com/gh/vektorcloud/mesos)

Tiny [Apache Mesos](mesos.apache.com) on Alpine.

### Running

    docker run --net host -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorcloud/mesos:latest mesos-local

### Building

    docker build -t mesos-base:latest .
    docker run --rm -t -v $PWD:/target mesos-base:latest cp -Rvf /mesos-tiny /target/
    docker build -f Dockerfile_tiny -t quay.io/vektorcloud/mesos:latest .
