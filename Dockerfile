FROM ubuntu:14.04

RUN apt-get -yqq update && \
    apt-get -yqq install build-essential \
                libcurl4-nss-dev libsasl2-dev libsasl2-modules \
                libapr1-dev libsvn-dev autoconf libtool git \
                python-pip && \
    pip install dockerize

COPY mesos-src /tmp/mesos-src

RUN cd /tmp/mesos-src && ./bootstrap && \
    ./configure --prefix=/opt/mesos --disable-java --disable-python && \
    make -j "$(cat /proc/cpuinfo |grep processor |wc -l)" V=0 && \
    make install

RUN dockerize -n -o /mesos-tiny $(find /opt/mesos/ -type f)
