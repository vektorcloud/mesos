FROM quay.io/vektorcloud/base:latest

ENV VERSION="1.1.x"
ENV PACKAGE="mesos-$VERSION-tiny.tar.gz"

RUN apk update && apk --no-cache add docker \
  libstdc++ \
  subversion \
  curl \
  fts \
  openssl  \
  openjdk8  \
  bash && \
  apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add dumb-init

# Mesos
ENV MESOS_WORK_DIR /opt/mesos
ENV MESOS_CONTAINERIZERS docker,mesos
# https://mesosphere.github.io/marathon/docs/native-docker.html
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins
# https://issues.apache.org/jira/browse/MESOS-3793
ENV MESOS_LAUNCHER posix
# TODO: Should update at compile time
ENV MESOS_WEBUI_DIR /share/mesos/webui
ENV MESOS_LOG_DIR /opt/mesos/log
ENV MESOS_LOGGING_LEVEL=WARNING

RUN wget "https://github.com/vektorlab/mesos-packaging/releases/download/$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  wget "https://github.com/vektorlab/mesos-packaging/releases/download/$VERSION/$PACKAGE.md5" -O "/tmp/$PACKAGE.md5" && \
  cd /tmp && \
  md5sum -c "$PACKAGE.md5" && \
  cd .. && \
  tar xvf "/tmp/$PACKAGE" && \
  rm -Rvf /tmp/mesos*
  
# Zookeeper
ENV ZOOKEEPER_tickTime=2000
ENV ZOOKEEPER_dataDir=/var/run/zookeeper
ENV ZOOKEEPER_clientPort=2181
ENV ZOOKEEPER_initLimit=5
ENV ZOOKEEPER_syncLimit=2

RUN mkdir /opt && \
  VERSION="3.4.9" && \
  PACKAGE="zookeeper-$VERSION.tar.gz" && \
  wget "http://www-us.apache.org/dist/zookeeper/zookeeper-$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  wget "http://www-us.apache.org/dist/zookeeper/zookeeper-$VERSION/$PACKAGE.md5" -O "/tmp/$PACKAGE.md5" && \
  cd /tmp && \
  md5sum -c "$PACKAGE.md5" && \
  tar xvf $PACKAGE -C /opt/ && \
  ln -sv /opt/zookeeper-* /opt/zookeeper

# Marathon
ENV MESOS_NATIVE_JAVA_LIBRARY /lib/libmesos.so
ENV MARATHON_LOGGING_LEVEL=warn

RUN VERSION=1.3.5 && \
  PACKAGE="marathon-$VERSION.tgz" && \
  wget "http://downloads.mesosphere.com/marathon/v$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  tar xvf "/tmp/$PACKAGE" -C /opt && \
  ln -sv /opt/marathon-* /opt/marathon && \
  rm -v /tmp/marathon*

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
