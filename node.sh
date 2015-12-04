#!/bin/bash

MASTER_IP=$(cat /etc/hosts | grep riak_master | awk '{print $1}' | head -1)

echo "[Riak Node] Joining cluster at riak@${MASTER_IP}..."
${RIAK_ADMIN} join -f riak@${MASTER_IP}
