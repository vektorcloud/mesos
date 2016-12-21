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

# Hadoop
# Reduces image size by deleting files unrelated to 
# hadoop distcp (which is used by Mesos Fetcher) for s3,
# and hdfs prefixes. Can remove after 
# https://issues.apache.org/jira/browse/MESOS-3918
RUN VERSION="2.7.3" && \
  PACKAGE="hadoop-$VERSION.tar.gz" && \
  wget "http://www-us.apache.org/dist/hadoop/common/hadoop-$VERSION/$PACKAGE" -O "/tmp/$PACKAGE" && \
  mkdir /opt && \
  cd /opt && \
  tar xvf /tmp/hadoop-2.7.3.tar.gz  && \
  ln -sv /opt/hadoop-2.7.3 /opt/hadoop && \
  rm -Rvf /tmp/* && \
  rm -Rvf /opt/hadoop/share/doc && \
  rm -Rvf /opt/hadoop/share/hadoop/hdfs && \
  rm -Rvf /opt/hadoop/share/hadoop/httpfs && \
  rm -Rvf /opt/hadoop/share/hadoop/kms && \
  rm -Rvf /opt/hadoop/share/hadoop/yarn
 
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

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
