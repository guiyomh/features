#!/usr/bin/env bash

# This test can be run with the following command (from the root of this repo)
#    devcontainer features test \
#               --features pact-go \
#               --base-image mcr.microsoft.com/devcontainers/go:latest .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "libpact_ffi found" pact-go install | grep "libpact_ffi found"
check "pact-go version" pact-go version

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
