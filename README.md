# mesos

Apache Mesos with Docker


    docker run --net host -v /var/run/docker.sock:/var/run/docker.sock -v /sys/fs/cgroup:/sys/fs/cgroup -v /sys:/sys -e MESOS_CONTAINERIZERS="docker,mesos" vektorcloud/mesos:0.28.0 mesos-local
