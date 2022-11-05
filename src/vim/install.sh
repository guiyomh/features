#!/usr/bin/env bash

echo "Activating vim ..."

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# shellcheck source=/dev/null
source /etc/os-release

export DEBIAN_FRONTEND=noninteractive

# Clean up
cleanup() {
case "${ID}" in
    debian|ubuntu)
      rm -rf /var/lib/apt/lists/*
    ;;
  esac
}

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

echo "Installing vim ..."

check_packages vim

vim --version

cleanup

echo "Done!"