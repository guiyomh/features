#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.


default_image:="base"
# default tag for test recipe (ubuntu,debian,alpine)
default_tag:="debian"

default:
    @just --list

# run global test
global:
    devcontainer features test --global-scenarios-only .

# test the given feature
test feature image=default_image tag=default_tag: cleanup
    devcontainer features test \
        --features {{feature}} \
        --skip-scenarios \
        --base-image mcr.microsoft.com/devcontainers/{{image}}:{{tag}} .

cleanup:
    -docker rm -f $(docker ps -a -q)
    -docker image rm -f $(docker image ls -q)

exec-last:
    docker exec -ti $(docker ps -q | head -n 1) bash