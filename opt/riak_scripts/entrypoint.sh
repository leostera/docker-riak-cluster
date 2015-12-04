#!/bin/sh

set -e

readonly IP=$(ifconfig eth0 | grep "inet\>" | awk '{ print $2 }' | awk -F ':' '{print $2}')
echo "Updating vm.args host to ${IP}..."
sed -i "s/host/${IP}/g" /etc/riak/vm.args
echo "OK"

export HOME=/var/lib/riak
/etc/init.d/riak start
/etc/init.d/riak status

echo "Executing post-start script..."
source /opt/riak_scripts/post-start.sh
echo "OK"

tail -f /var/log/riak/*
