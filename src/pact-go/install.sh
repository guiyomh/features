#!/usr/bin/env bash

echo "Activating pact-go ..."

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

PACTGO_VERSION=${VERSION:-"2.0.0-beta.10"}
USER=${2:-"automatic"}

export DEBIAN_FRONTEND=noninteractive

# shellcheck source=/dev/null
source /etc/os-release

apt_get_update() {
  case "${ID}" in
    debian|ubuntu)
      if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
      fi
    ;;
  esac
}

# Checks if packages are installed and installs them if not
check_packages() {
  case "${ID}" in
    debian|ubuntu)
      if ! dpkg -s "$@" >/dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
      fi
    ;;
    alpine)
      if ! apk -e info "$@" >/dev/null 2>&1; then
        apk add --no-cache "$@"
      fi
    ;;
  esac
}


echo "Installing pact-go..."

# Install dependencies if missing
check_packages curl ca-certificates

curl -sL -o /tmp/pact-go.tar.gz "https://github.com/pact-foundation/pact-go/releases/download/v${PACTGO_VERSION}/pact-go_${PACTGO_VERSION}_linux_amd64.tar.gz"
tar xzf /tmp/pact-go.tar.gz pact-go
mv pact-go /usr/local/bin/pact-go
rm /tmp/pact-go.tar.gz

pact-go -l DEBUG install
chmod 0755 /usr/local/lib/libpact_ffi.so

echo "Done!"
