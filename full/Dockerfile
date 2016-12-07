FROM quay.io/vektorcloud/base:latest

RUN apk --no-cache add docker \
  libstdc++ \
  subversion \
  curl \
  fts \
  openjdk8 \
  openssl  \
  bash && \
  apk --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community add dumb-init

# Mesos
RUN VERSION="1.1.x" && \
  PACKAGE="mesos-$VERSION-tiny.tar.gz" && \
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

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
