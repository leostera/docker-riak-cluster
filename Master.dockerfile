FROM       riak-node 
MAINTAINER Leandro Ostera <leandro@ostera.io>

COPY ./master.sh /opt/riak_scripts/post-start.sh
