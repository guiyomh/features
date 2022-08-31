#!/usr/bin/env bash

echo "Activating golangci-lint ..."

VERSION=${VERSION:-"latest"}

echo "Installing golangci-lint ..."

go install github.com/golangci/golangci-lint/cmd/golangci-lint@"${VERSION}"

golangci-lint --version

echo "Done!"
