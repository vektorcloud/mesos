FROM ubuntu:latest

RUN apt-get -yqq update && \
    apt-get install -yq curl git python-pip && \
    git clone https://github.com/larsks/dockerize.git && \
    cd dockerize && python setup.py install

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    echo deb http://repos.mesosphere.io/ubuntu trusty main > /etc/apt/sources.list.d/mesosphere.list && \
    apt-get -yqq update && apt-get -yq install mesos=0.28.0-2.0.16.ubuntu1404

RUN dockerize --debug -n -o /mesos-tiny \
              -a /usr/lib/libmesos-0.28.0.so /usr/lib/libmesos-0.28.0.so \
              -a /usr/lib/libmesos.so /usr/lib/libmesos.so \
              $(dpkg -L mesos | egrep '(sbin/|bin/)')
