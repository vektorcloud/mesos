# Tiny Mesos

[![Circle CI](https://circleci.com/gh/vektorcloud/mesos.svg?style=svg)](https://circleci.com/gh/vektorcloud/mesos)

Tiny [Apache Mesos](mesos.apache.com) on Alpine.

### Running

    docker run --net host -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorcloud/mesos:latest mesos-local
