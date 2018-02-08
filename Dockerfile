FROM quay.io/vektorcloud/base:3.7 AS build

ENV \
  VERSION="1.4.1" \
  BASE_URL="http://www-eu.apache.org/dist/mesos" \
  CONFIG_FLAGS="--disable-python --enable-optimize" \
  MAKE_FLAGS="-j 3" \
  JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"

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
  && apk update \
  && apk add $(cat /tmp/deps.txt) \
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
  && make $MAKE_FLAGS 

RUN cd /tmp/mesos/mesos-* \
  && mkdir /mesos \
  && make install  DESTDIR=/mesos

FROM quay.io/vektorcloud/base:3.7

RUN apk add --no-cache \
  bash \
  binutils \
  coreutils \
  curl \
  dumb-init \
  docker \
  fts \
  libstdc++ \
  openssl \
  subversion \
  libarchive-tools \
  && mkdir -p /var/run/mesos \
  && rm -v /usr/bin/docker-* /usr/bin/dockerd \
  && cp $(which tar) $(which tar)~ \
  && ln -sf $(which bsdtar) $(which tar)

# Mesos Default Options
ENV \ 
  MESOS_ZK="zk://localhost:2181/mesos" \
  MESOS_MASTER="zk://localhost:2181/mesos" \
  MESOS_QUORUM="1" \
  MESOS_CONTAINERIZERS="mesos" \ 
  MESOS_EXECUTOR_REGISTRATION_TIMEOUT="5mins" \
  MESOS_LAUNCHER="posix" \
  MESOS_LOGGING_LEVEL="WARNING" \
  MESOS_SYSTEMD_ENABLE_SUPPORT="false" \
  MESOS_ISOLATION="posix/cpu,posix/mem" \
  MESOS_IMAGE_PROVIDERS="APPC"

COPY --from=build /mesos/usr/local/ /usr/local/

VOLUME /var/run/mesos

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
