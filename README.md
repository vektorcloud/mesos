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

##### Special Options

This container provides several special options to make configuration more convienent.

###### Masters

The `MASTERS` environment variable may be specified to automatically populate configuration values for high availability.

For example, by specifying `MASTERS=master0.domain.com;master1.domain.com;master2.domain.com`, the container 
will configure Zookeeper, Mesos master and agents appropriately.

##### Mesos Master & Mesos Agent
The Mesos master and agent processes can be configured with environment variables prefixed with `MESOS_MASTER_` or `MESOS_AGENT_`.
Configuration options that effect both processes can be specified with the `MESOS_` prefix. Read more about Mesos commandline options
in the Mesos [documentation](http://mesos.apache.org/documentation/latest/configuration/).

##### Zookeeper
Zookeeper options can be configured by setting environment variables prefixed with `ZOOKEEPER_`. For example, to
configure the Zookeeper option `autopurge.purgeInterval=1` you may specify the environment variable
`ZOOKEEPER_autopurge_purgeInterval=1`. You can read about most useful Zookeeper options in the [Getting Started Guide](https://zookeeper.apache.org/doc/trunk/zookeeperStarted.html).
