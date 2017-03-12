FROM quay.io/vektorcloud/base:3.5

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

RUN VERSION="2.7.3" && \
  PACKAGE="hadoop-$VERSION.tar.gz" && \
  wget "http://www-us.apache.org/dist/hadoop/common/hadoop-$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  mkdir /opt && \
  cd /opt && \
  tar xvf "/tmp/$PACKAGE"  && \
  ln -sv "/opt/hadoop-$VERSION" /opt/hadoop && \
  rm -Rvf /tmp/* && \
  rm -Rvf /opt/hadoop/share/doc && \
  rm -Rvf /opt/hadoop/share/hadoop/hdfs && \
  rm -Rvf /opt/hadoop/share/hadoop/httpfs && \
  rm -Rvf /opt/hadoop/share/hadoop/kms
 
# Hadoop options 
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CLASSPATH="$HADOOP_HOME/share/hadoop/tools/lib/*"
ENV PATH="$HADOOP_HOME/bin:$PATH"

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
ENV MESOS_LAUNCHER="posix"
# TODO: Should update at compile time
ENV MESOS_WEBUI_DIR="/share/mesos/webui"
ENV MESOS_LOG_DIR="/opt/mesos/log"
ENV MESOS_LOGGING_LEVEL="WARNING"
ENV MESOS_LAUNCHER_DIR="/libexec/mesos"
ENV MESOS_SYSTEMD_ENABLE_SUPPORT="false"

COPY mesos/out/usr/ /usr/

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
