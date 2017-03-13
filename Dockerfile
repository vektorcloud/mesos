FROM quay.io/vektorcloud/base:3.4

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


# Mesos Default Options
ENV \ 
  VERSION="1.2.0" \
  MESOS_ZK="zk://localhost:2181/mesos" \
  MESOS_MASTER="zk://localhost:2181/mesos" \
  MESOS_QUORUM="1" \
  MESOS_WORK_DIR="/mesos" \
  MESOS_LOG_DIR="/mesos/log" \
  MESOS_CONTAINERIZERS="mesos,docker" \ 
  MESOS_EXECUTOR_REGISTRATION_TIMEOUT="5mins" \
  MESOS_LAUNCHER="posix" \
  MESOS_LOGGING_LEVEL="WARNING" \
  MESOS_SYSTEMD_ENABLE_SUPPORT="false"

COPY mesos/mesos-$VERSION/build /

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
