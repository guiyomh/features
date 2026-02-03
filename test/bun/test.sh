#!/usr/bin/env bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "bun is installed" command -v bun
check "bun version" bun --version

# Report result
reportResults
