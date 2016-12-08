FROM quay.io/vektorcloud/base:latest

RUN apk --no-cache add docker \
  libstdc++ \
  subversion \
  curl \
  fts \
  openjdk8 \
  openssl  \
  binutils \
  bash && \
  apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add dumb-init

# Mesos
RUN VERSION="1.1.x" && \
  PACKAGE="mesos-$VERSION-musl.tar.gz" && \
  wget "https://github.com/vektorlab/mesos-packaging/releases/download/$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  wget "https://github.com/vektorlab/mesos-packaging/releases/download/$VERSION/$PACKAGE.md5" -O "/tmp/$PACKAGE.md5" && \
  cd /tmp && \
  md5sum -c "$PACKAGE.md5" && \
  cd .. && \
  tar xvf "/tmp/$PACKAGE" && \
  rm -Rvf /tmp/mesos*
  
# Zookeeper
RUN VERSION="3.4.9" && \
  PACKAGE="zookeeper-$VERSION.tar.gz" && \
  mkdir /opt && \
  wget "http://www-us.apache.org/dist/zookeeper/zookeeper-$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  wget "http://www-us.apache.org/dist/zookeeper/zookeeper-$VERSION/$PACKAGE.md5" -O "/tmp/$PACKAGE.md5" && \
  cd /tmp && \
  md5sum -c "$PACKAGE.md5" && \
  tar xvf $PACKAGE -C /opt/ && \
  ln -sv /opt/zookeeper-* /opt/zookeeper && \
  rm -v /tmp/zookeeper*

# Option Flags
ENV ZK_PORT="2181"

# Default Options
# Mesos Master
ENV MESOS_ZK="zk://localhost:2181/mesos"
ENV MESOS_QUORUM="1"
# Mesos Agent
ENV MESOS_WORK_DIR="/opt/mesos"
ENV MESOS_MASTER="zk://localhost:2181/mesos"
ENV MESOS_CONTAINERIZERS="docker,mesos"
# https://mesosphere.github.io/marathon/docs/native-docker.html
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT="5mins"
# https://issues.apache.org/jira/browse/MESOS-3793
ENV MESOS_LAUNCHER="posix"
# TODO: Should update at compile time
ENV MESOS_WEBUI_DIR="/share/mesos/webui"
ENV MESOS_LOG_DIR="/opt/mesos/log"
ENV MESOS_LOGGING_LEVEL="WARNING"
ENV MESOS_LAUNCHER_DIR="/libexec/mesos"
ENV MESOS_SYSTEMD_ENABLE_SUPPORT="false"

ENV ZOOKEEPER_tickTime="2000"
ENV ZOOKEEPER_dataDir="/var/run/zookeeper"
ENV ZOOKEEPER_clientPort="2181"
ENV ZOOKEEPER_initLimit="5"
ENV ZOOKEEPER_syncLimit="2"

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
