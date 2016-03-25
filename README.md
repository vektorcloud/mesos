# mesos

Apache Mesos with Docker

[![Circle CI](https://circleci.com/gh/vektorcloud/mesos.svg?style=svg)](https://circleci.com/gh/vektorcloud/mesos)


    # Run mesos-local
    docker run --net host -v /var/run/docker.sock:/var/run/docker.sock -v /sys/fs/cgroup:/sys/fs/cgroup -v /sys:/sys -e MESOS_CONTAINERIZERS="docker,mesos" vektorcloud/mesos:0.28.0 mesos-local
