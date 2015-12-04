###========================================================================
### Author: Leandro Ostera       <leandro@ostera.io>
###========================================================================
FROM       centos6
MAINTAINER Leandro Ostera <leandro@ostera.io>

ENV RIAK_V_MAJ    1
ENV RIAK_V_MIN    4
ENV RIAK_V_INC    1
ENV RIAK_V_BUILD  1.el6

ENV RIAK_VERSION        ${RIAK_V_MAJ}.${RIAK_V_MIN}
ENV RIAK_VERSION_FULL   ${RIAK_V_MAJ}.${RIAK_V_MIN}.${RIAK_V_INC}-${RIAK_V_BUILD} 
ENV RIAK_REPO_BASE      http://s3.amazonaws.com/downloads.basho.com/riak
ENV RIAK_REPO           ${RIAK_REPO_BASE}/${RIAK_VERSION}/${RIAK_VERSION}.${RIAK_V_INC}/rhel/6
ENV RIAK_PACKAGE        riak-${RIAK_VERSION_FULL}.x86_64.rpm 
ENV RIAK_URI            ${RIAK_REPO}/${RIAK_PACKAGE}

ENV RIAK_HANDOFF_PORT   8099
ENV RIAK_HTTP_PORT      8091
ENV RIAK_PB_PORT        8081

ENV RIAK                /usr/sbin/riak
ENV RIAK_ADMIN          /usr/sbin/riak-admin

# Expose Riak ports
EXPOSE $RIAK_HANDOFF_PORT $RIAK_HTTP_PORT $RIAK_PB_PORT

# Install Dependencies
COPY ./etc/yum.repos.d /etc/yum.repos.d
RUN yum makecache fast && \
    yum install -y \
      util-linux-ng \
      wget \
    && yum clean all \

# Install Riak
RUN wget $RIAK_URI && \
    yum install -y $RIAK_PACKAGE && \
    rm $RIAK_PACKAGE

COPY ./etc/riak /etc/riak

RUN mkdir -p /var/lib/riak && \
    mkdir -p /logs/riak && \
    mkdir -p /data/riak/{platform_data,ring_state} && \
    chown -R riak:riak /var && \
    chown -R riak:riak /etc/riak && \
    chown -R riak:riak /data && \
    chmod -R +rw /etc/riak

COPY ./opt/riak_scripts /opt/riak_scripts
RUN chmod -R +rx /opt/riak_scripts

USER riak
ENTRYPOINT ["/opt/riak_scripts/entrypoint.sh"]
