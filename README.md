# [Apache Mesos](https://mesos.apache.org) on Alpine

![circleci][circleci]

[![Docker Repository on Quay](https://quay.io/repository/vektorcloud/mesos/status "Docker Repository on Quay")](https://quay.io/repository/vektorcloud/mesos)

## Versions

Mesos  | Alpine  | Docker (client)
-------|---------|---------------
|1.4.0 |3.6      |17.07.0-ce

## Purpose

This repository maintains a Docker image with the latest stable release of Apache Mesos compiled on Alpine with [musl-libc](https://www.musl-libc.org/). With all compiled Mesos binaries and the Docker client the image size is `~126MB`.

#### Usage

The easiest way to run Mesos locally for development and testing is to use `mesos-local` which has no dependency on Zookeeper and runs the Master and agent processes together.

The image is configured by default to have limited isolation capabilities.


    # Basic isolation
    docker run --rm -ti -p 5050:5050 -p 5051:5051 quay.io/vektorcloud/mesos mesos-local
    # Only Docker isolation
    docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock -e MESOS_ISOLATION=docker/runtime quay.io/vektorcloud/mesos mesos-local
    # Mesos only containerizer with support for Docker images
    docker run --rm -ti --privileged -e MESOS_LAUNCHER=linux -e MESOS_ISOLATION=cgroups/cpu,cgroups/mem,cgroups/pids,namespaces/pid -e MESOS_IMAGE_PROVIDERS=APPC,DOCKER quay.io/vektorcloud/mesos mesos-local
    # Run with full support for cgroup isolation
    docker run --rm -ti --privileged -e MESOS_LAUNCHER=linux -e MESOS_ISOLATION=cgroups/cpu,cgroups/mem,cgroups/pids,namespaces/pid,filesystem/shared,filesystem/linux,volume/sandbox_path mesos-local


You can then verify it is running by browsing to `http://localhost:5050`


#### Configuration

All configuration options are specified with environment variables. Take a look at 
the [documentation](https://mesos.apache.org/documentation/latest/configuration/) for more details.

[circleci]: https://img.shields.io/circleci/project/github/vektorcloud/mesos.svg "mesos"
