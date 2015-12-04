#!/bin/bash

# Start up the riak search service.
echo "[Riak Master] Waiting for Riak Search service..."
readonly RIAK_MASTER=riak@${IP}

${RIAK_ADMIN} wait-for-service riak_search ${RIAK_MASTER}
