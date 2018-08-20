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
    retry: 5
    curl: ':8080/healthcheck'
    pipe: grep -qw 'online'
    post_exec: |
      grep -q 'teststring' /var/thing/file; another-command
```

### Available options
- `repo`          tag for the image to run and test _required_
- `delay`         startup delay for the container before executing any actions
- `retry`         curl retry count before giving up
- `retry_delay`   curl delay before retrying
- `pipe`          shell code to execute on curl output. useful for ensuring output correctness
- `pre_exec`      shell commands inside the container to run before curl _optional_
- `post_exec`     shell commands inside the container to run after curl _optional_
- `curl`          url path to curl _e.g. `:8080/directory`_ _optional_
- `curl_opts`     additional options to pass to curl _optional_
- `run_args`      arguments to pass to `docker create` _optional_
- `run_cmd`       override docker container CMD _optional_
- `verbose`       print curl output and running commands. _default_ `false`
