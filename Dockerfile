ARG DOCKER_VER=18.06.1-ce

FROM docker:${DOCKER_VER}

ARG VCS_REF
ARG DOCKER_VER

LABEL maintainer="Spritsail <docker-plugin@spritsail.io>" \
      org.label-schema.vendor="Spritsail" \
      org.label-schema.name="docker-test" \
      org.label-schema.description="A Drone CI plugin for testing Docker images" \
      org.label-schema.version=${VCS_REF} \
      io.spritsail.version.docker-test=${VCS_REF} \
      io.spritsail.version.docker=${DOCKER_VER}

ADD test.sh label /usr/local/bin/
RUN chmod 755 /usr/local/bin/*.sh && \
    apk --no-cache add curl jq xmlstarlet grep

ENTRYPOINT [ "/usr/local/bin/test.sh" ]
