#!/usr/bin/dumb-init /bin/bash
set -e

PIDS=""

[ -n "$WITH_MESOS_MASTER" ] && {
  env |grep "MESOS_"
  /sbin/mesos-master &
  PIDS="$PIDS $!"
}

[ -n "$WITH_MESOS_AGENT" ] && {
  env |grep "MESOS_"
  /sbin/mesos-agent &
  PIDS="$PIDS $!"
}

# Wait for all processes to complete.
if [ "$PIDS" != "" ]; then
  wait $PIDS
else
  exec "$@"
fi
