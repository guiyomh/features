#!/usr/bin/env bash

echo "Activating goreleaser ..."

VERSION=${VERSION:-"latest"}

echo "Installing goreleaser ..."

go install github.com/goreleaser/goreleaser@"${VERSION}"

goreleaser --version

echo "Done!"
