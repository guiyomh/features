#!/usr/bin/env bash

set -e

# shellcheck source=/dev/null
source dev-container-features-test-lib

# Feature-specific tests
check "fish version" fish -v  | grep "version"
check "fisher version" fish -c "fisher -v"
check "pure-fish/pure installed" fish -c "fisher list" | grep "pure"

# Report result
reportResults