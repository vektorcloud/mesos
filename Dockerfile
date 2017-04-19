FROM quay.io/vektorcloud/base:3.5

ARG CONFIG_FLAGS="--disable-java --disable-python --enable-optimize"
ARG MAKE_FLAGS="-j 3"

ENV \
  VERSION="1.2.0" \
  BASE_URL="http://www-eu.apache.org/dist/mesos" \
  CONFIG_FLAGS=$CONFIG_FLAGS \
  MAKE_FLAGS=$MAKE_FLAGS

RUN \
  PACKAGE="mesos-$VERSION".tar.gz \
  PACKAGE_URL="$BASE_URL/$VERSION/$PACKAGE" \
  KEYS_URL="$BASE_URL"/KEYS \
  && echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community" |tee >> /etc/apk/repositories \
  && echo "@edge.testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" |tee >> /etc/apk/repositories \
  && echo apr \
    apr-dev \
    autoconf \
    automake \
    boost \
    boost-dev \
    curl \
    curl-dev \
    cyrus-sasl-crammd5 \
    cyrus-sasl-dev \
    file \
    fts \
    fts-dev \
    g++ \
    git \
    glog@edge.testing \
    glog-dev@edge.testing \
    gpgme \
    libtool \
    linux-headers \
    make \
    maven@edge \
    openjdk8 \
    openssl \
    patch \
    python \
    python-dev \
    subversion \
    subversion-dev \
    zlib \
    zlib-dev |tee > /tmp/deps.txt \
  && apk add --no-cache $(cat /tmp/deps.txt) \
  && ln -sv /usr/include/locale.h /usr/include/xlocale.h \
  && mkdir -p /tmp/mesos \
  && cd /tmp/mesos \
  && curl -L "$KEYS_URL" -o KEYS \
  && gpg --import KEYS \
  && curl -L "$PACKAGE_URL".asc -o "$PACKAGE".asc \
  && curl -L "$PACKAGE_URL" -o "$PACKAGE" \
  && gpg --verify "$PACKAGE".asc "$PACKAGE" \
  && tar xf "$PACKAGE" \
  && cd mesos-"$VERSION" \
  && ./configure $CONFIG_FLAGS \
  && make $MAKE_FLAGS \
  && make install \
  && cd / \
  && apk del $(cat /tmp/deps.txt) \
  && rm -rf /tmp/*
  
# Runtime dependencies
RUN echo docker \
    dumb-init@edge.community \
    libstdc++ \
    subversion \
    curl \
    fts \
    openssl  \
    binutils \
    coreutils \
    tar \
    bash |tee > /tmp/deps.txt \
    && apk add --no-cache $(cat /tmp/deps.txt) \
    && rm -v /tmp/deps.txt \
    && mkdir -p /var/run/mesos

# Mesos Default Options
ENV \ 
  MESOS_ZK="zk://localhost:2181/mesos" \
  MESOS_MASTER="zk://localhost:2181/mesos" \
  MESOS_QUORUM="1" \
  MESOS_WORK_DIR="/var/run/mesos" \
  MESOS_LOG_DIR="/var/run/mesos/log" \
  MESOS_CONTAINERIZERS="mesos,docker" \ 
  MESOS_EXECUTOR_REGISTRATION_TIMEOUT="5mins" \
  MESOS_LAUNCHER="linux" \
  MESOS_LOGGING_LEVEL="WARNING" \
  MESOS_SYSTEMD_ENABLE_SUPPORT="false" \
  MESOS_ISOLATION="cgroups/cpu,cgroups/mem,cgroups/pids,namespaces/pid,filesystem/shared,filesystem/linux,docker/runtime,volume/sandbox_path" \
  MESOS_IMAGE_PROVIDERS="DOCKER,APPC"

VOLUME /var/run/mesos

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
