# Apache Mesos on Alpine

[![Circle CI](https://circleci.com/gh/vektorcloud/mesos.svg?style=svg)](https://circleci.com/gh/vektorcloud/mesos)

[Apache Mesos](mesos.apache.com) on Alpine.

## Purpose

This repository aims to maintain a Docker image with the latest stable release of Apache Mesos compiled independent of Mesosphere and DC/OS. 


#### Usage

    docker run -ti --rm --net host -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorcloud/mesos:latest mesos-local
    # With extended privileges for the Mesos containerizer http://mesos.apache.org/documentation/latest/mesos-containerizer/
    docker run --ti --rm --net host --privileged -e MESOS_LAUNCHER=linux -v /var/run/docker.sock:/var/run/docker.sock quay.io/vektorcloud/mesos:latest mesos-local


#### Configuration

All configuration options are specified with environment variables.
