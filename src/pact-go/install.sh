#!/usr/bin/env bash

echo "Activating pact-go ..."

VERSION=${VERSION:-"latest"}

echo "Installing pact-go ..."

go install github.com/pact-foundation/pact-go/v2@"${VERSION}"
pact-go -l DEBUG install
chmod 0755 /usr/local/lib/libpact_ffi.so

echo "Done!"
