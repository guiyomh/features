#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile test`, for example.


default:
    @just --list

# run global test
global:
    devcontainer features test --global-scenarios-only .

# test the given feature
test feature:
    devcontainer features test \
        --features {{feature}} \
        --base-image mcr.microsoft.com/devcontainers/base:ubuntu .