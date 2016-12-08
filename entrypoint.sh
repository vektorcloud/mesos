#!/usr/bin/dumb-init /bin/bash
set -e

DELAY="sleep 2"

# Option Flags
ZK_PORT="${ZK_DEFAULT_PORT:=2181}"

PIDS=""

# Accept an environment variable named $MASTERS
# which is used to configure several options 
# for Zookeeper, and Mesos master/agents.
# Each master should be seperated by semicolon.
# master0.domain;master1.domain;master2.domain
[ -n "$MASTERS" ] && {
  IFS=';' read -ra HOSTS <<< "$MASTERS"
  COUNT="${#HOSTS[@]}"
  export MESOS_QUORUM=$(($COUNT/2+1))
  local zk_string="zk://"
  for (( i=0; i<$COUNT; i++ )); do
    if [ "$i" -gt 0 ]; then
      zk_string="$zk_string,"
    fi
    zk_string="$zk_string${HOSTS[$i]}:$ZK_PORT"
    export "ZOOKEEPER_server_$i=${HOSTS[$i]}:$ZK_PORT"
  done
  export MESOS_ZK="$zk_string/mesos"
  export MESOS_MASTER="$zk_string/mesos"
}

[ -n "$WITH_ZOOKEEPER" ] && {
  env |grep "ZOOKEEPER_"
  # Write Zookeeper Configuration
  cat /dev/null > /opt/zookeeper/conf/zoo.cfg
  for opt in $(env |grep ^ZOOKEEPER_); do
    echo $opt | awk '{gsub(/ZOOKEEPER_/, ""); gsub(/_/, "."); {print}}' >> /opt/zookeeper/conf/zoo.cfg
  done
  /opt/zookeeper/bin/zkServer.sh start-foreground &
  PIDS="$PIDS $!"
  $DELAY
}

[ -n "$WITH_MESOS_MASTER" ] && {
  env |grep "MESOS_"
  /sbin/mesos-master &
  PIDS="$PIDS $!"
  $DELAY
}

[ -n "$WITH_MESOS_AGENT" ] && {
  env |grep "MESOS_"
  /sbin/mesos-agent &
  PIDS="$PIDS $!"
  $DELAY
}

# Wait for all processes to complete.
# TODO: Script should exit if ANY process exits
if [ "$PIDS" != "" ]; then
  wait $PIDS
else
  exec "$@"
fi
