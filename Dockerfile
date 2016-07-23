FROM ubuntu:latest

ENV MESOS_VERSION "0.28.2-2.0.27.ubuntu1404"

RUN apt-get -yqq update && \
    apt-get install -yq curl git python-pip && \
    git clone https://github.com/larsks/dockerize.git && \
    cd dockerize && python setup.py install

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    echo deb http://repos.mesosphere.io/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list && \
    apt-get -yqq update && apt-get -yq install mesos=$MESOS_VERSION

RUN dockerize --debug -n -o /mesos-tiny \
              -a /usr/lib/libmesos-0.28.2.so /usr/lib/libmesos-0.28.2.so \
              -a /usr/lib/libmesos.so /usr/lib/libmesos.so \
              $(dpkg -L mesos | egrep '(sbin/|bin/|webui/|libexec\/mesos\/)') && \
    find /mesos-tiny -type f -exec chmod +r {} \;
