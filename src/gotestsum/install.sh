#!/usr/bin/env bash

echo "Activating gotestsum ..."

VERSION=${VERSION:-"latest"}

echo "Installing gotestsum ..."

go install gotest.tools/gotestsum@"${VERSION}"

gotestsum --version

echo "Done!"
