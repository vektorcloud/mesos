FROM quay.io/vektorcloud/base:latest

ENV VERSION="1.1.x"
ENV PACKAGE="mesos-$VERSION-tiny.tar.gz"

# Mesos runtime dependencies 
RUN apk update && apk --no-cache add docker \
  libstdc++ \
  subversion \
  curl \
  fts \
  openssl && \
  apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add dumb-init

RUN wget "https://github.com/vektorlab/mesos-packaging/releases/download/$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  wget "https://github.com/vektorlab/mesos-packaging/releases/download/$VERSION/$PACKAGE.md5" -O "/tmp/$PACKAGE.md5" && \
  cd /tmp && \
  md5sum -c "$PACKAGE.md5" && \
  cd .. && \
  tar xvf "/tmp/$PACKAGE" && \
  rm -Rvf /tmp/mesos*
  

COPY entrypoint.sh /

ENV MESOS_WORK_DIR /opt/mesos
ENV MESOS_CONTAINERIZERS docker,mesos
# https://mesosphere.github.io/marathon/docs/native-docker.html
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins
# https://issues.apache.org/jira/browse/MESOS-3793
ENV MESOS_LAUNCHER posix
# TODO: Should update at compile time
ENV MESOS_WEBUI_DIR /share/mesos/webui
ENV MESOS_LOG_DIR /opt/mesos/log

ENTRYPOINT ["/entrypoint.sh"]
