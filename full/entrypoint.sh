#!/usr/bin/dumb-init /bin/bash
set -e

# Option Flags
ZK_PORT="${ZK_DEFAULT_PORT:=2181}"

PIDS=""

# Accept an environment variable named $MASTERS
# which is used to configure several options 
# for Zookeeper, Marathon, and Mesos master/agents.
# Each master should be seperated by semicolon.
# master0.domain;master1.domain;master2.domain
function config_master {
  IFS=';' read -ra HOSTS <<< "$MASTERS"
  COUNT="${#HOSTS[@]}"
  export MESOS_MASTER_QUORUM=$(($COUNT/2+1))
  local zk_string="zk://"
  for (( i=0; i<$COUNT; i++ )); do
    if [ "$i" -gt 0 ]; then
      zk_string="$zk_string,"
    fi
    zk_string="$zk_string${HOSTS[$i]}:$ZK_PORT"
    export "ZOOKEEPER_server_$i=${HOSTS[$i]}:$ZK_PORT"
  done
  export MESOS_MASTER_ZK="$zk_string/mesos"
  export MESOS_AGENT_MASTER="$zk_string/mesos"
  export MARATHON_ZK="$zk_string/marathon"
  export MARATHON_MASTER="$zk_string/mesos"
}

# Zookeeper
[ -n "$WITH_ZOOKEEPER" ] && {
  # Write Zookeeper Configuration
  cat /dev/null > /opt/zookeeper/conf/zoo.cfg
  for opt in $(env |grep ^ZOOKEEPER_); do
    echo $opt | awk '{gsub(/ZOOKEEPER_/, ""); gsub(/_/, "."); {print}}' >> /opt/zookeeper/conf/zoo.cfg
  done
  /opt/zookeeper/bin/zkServer.sh start-foreground &
  PIDS="$PIDS $!"
}

# Mesos Master
[ -n "$WITH_MESOS_MASTER" ] && {
  /sbin/mesos-master &
  PIDS="$PIDS $!"
}

# Mesos Agent
[ -n "$WITH_MESOS_AGENT" ] && {
  /sbin/mesos-agent &
  PIDS="$PIDS $!"
}

[ -n "$WITH_MARATHON" ] && {
  /opt/marathon/bin/start &
  PIDS="$PIDS $!"
}

# Wait for all processes to complete.
# TODO: Should script should exit if ANY process exits
if [ "$PIDS" != "" ]; then
  if [ "$MASTERS" != "" ]; then
    config_master
  fi
  wait $PIDS
else
  exec "$@"
fi
