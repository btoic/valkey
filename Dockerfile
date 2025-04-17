FROM valkey/valkey:7.2.8-alpine

LABEL maintainer="Branko Toic"

ARG TARGETARCH

ENV REDIS_PORT=6379

LABEL version=1.0 \
      arch=$TARGETARCH \
      description="A production grade performance tuned valkey docker image for opstree redis-operator"

RUN apk update && apk upgrade && apk add --no-cache bash

COPY redis.conf /etc/redis/redis.conf

COPY entrypoint.sh /usr/bin/entrypoint.sh

COPY setupMasterSlave.sh /usr/bin/setupMasterSlave.sh

COPY healthcheck.sh /usr/bin/healthcheck.sh

RUN chown -R 1000:0 /etc/redis && \
    chmod -R g+rw /etc/redis && \
    mkdir -p /data && \
    chown -R 1000:0 /data && \
    chmod -R g+rw /data && \
    mkdir -p /node-conf && \
    chown -R 1000:0 /node-conf && \
    chmod -R g+rw /node-conf && \
    chmod -R g+rw /var/run

VOLUME ["/data"]
VOLUME ["/node-conf"]

WORKDIR /data

EXPOSE ${REDIS_PORT}

USER 1000

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
