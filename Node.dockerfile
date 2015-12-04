FROM       riak-node 
MAINTAINER Leandro Ostera <leandro@ostera.io>

COPY ./node.sh /opt/riak_scripts/post-start.sh
