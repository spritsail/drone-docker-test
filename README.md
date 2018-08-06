[hub]: https://hub.docker.com/r/spritsail/docker-test
[git]: https://github.com/spritsail/drone-docker-test
[drone]: https://drone.spritsail.io/spritsail/docker-test
[mbdg]: https://microbadger.com/images/spritsail/docker-test

# [Spritsail/docker-test][hub]
[![Layers](https://images.microbadger.com/badges/image/spritsail/docker-test.svg)][mbdg]
[![Latest Version](https://images.microbadger.com/badges/version/spritsail/docker-test.svg)][hub]
[![Git Commit](https://images.microbadger.com/badges/commit/spritsail/docker-test.svg)][git]
[![Docker Stars](https://img.shields.io/docker/stars/spritsail/docker-test.svg)][hub]
[![Docker Pulls](https://img.shields.io/docker/pulls/spritsail/docker-test.svg)][hub]
[![Test Status](https://drone.spritsail.io/api/badges/spritsail/drone-docker-test/status.svg)][drone]

A plugin for [Drone CI](https://github.com/drone/drone) to start and test build docker images

## Supported tags and respective `Dockerfile` links

`latest` - [(Dockerfile)](https://github.com/spritsail/drone-docker-test/blob/master/Dockerfile)

## Configuration

An example configuration of how the plugin should be configured:
```yaml
pipeline:
  test:
    image: spritsail/docker-test
    volumes: [ '/var/run/docker.sock:/var/run/docker.sock' ]
    repo: test-me:latest
    curl: ':8080/healthcheck
    retry: 5
    pipe: grep -qw 'online'
```

### Available options
- `repo`          tag for the image to run and test
- `delay`         startup delay for the container before curl'ing it
- `retry`         curl retry count before giving up
- `retry_delay`   curl delay before retrying
- `pipe`          shell code to execute on curl output. useful for ensuring output correctness
- `curl_opts`     additional options to pass to curl
- `run_args`      arguments to pass to `docker create`
- `run_cmd`       override docker container CMD
