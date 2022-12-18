ARG DOCKER_VER=24-cli

FROM docker:${DOCKER_VER}

ARG VCS_REF
ARG DOCKER_VER

LABEL org.opencontainers.image.authors="Spritsail <docker-plugin@spritsail.io>" \
      org.opencontainers.image.title="docker-test" \
      org.opencontainers.image.description="A Drone CI plugin for testing Docker images" \
      org.opencontainers.image.version=${VCS_REF} \
      io.spritsail.version.docker=${DOCKER_VER}

ADD test.sh label /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh && \
    apk --no-cache add curl jq xmlstarlet grep coreutils

ENTRYPOINT [ "/usr/local/bin/test.sh" ]
