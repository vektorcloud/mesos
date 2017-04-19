#!/usr/bin/dumb-init /bin/bash
set -e

# Libprocess MUST be able to resolve our hostname
# Some environments such as runc don't automatically
# specify this like Docker does. It can also be used
# with the --discover-ip flag
cat > /sbin/discover-ip <<-__EOF__ 
#!/bin/sh
ip addr |grep 'state UP' -A2 |tail -n1 | awk '{print \$2}' | sed 's/\/.*//'
__EOF__

chmod +x /sbin/discover-ip

[ -n "$DISCOVER_IP" ] && {
  sleep 10
  echo "$(discover-ip)      $(hostname)" >> /etc/hosts
}

exec "$@"
