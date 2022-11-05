#!/usr/bin/env bash

DAGGER_VERSION=${VERSION:-"latest"}

set -e

# shellcheck source=/dev/null
source /etc/os-release

# Clean up
cleanup() {
case "${ID}" in
    debian|ubuntu)
      rm -rf /var/lib/apt/lists/*
    ;;
  esac
}

cleanup

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

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

check_git() {
    if [ ! -x "$(command -v git)" ]; then
        check_packages git
    fi
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

find_version_from_git_tags() {
    local variable_name=$1
    local requested_version=${!variable_name}
    if [ "${requested_version}" = "none" ]; then return; fi

    if [ "$(echo "${requested_version}" | grep -o "." | wc -l)" != "2" ]; then
        local version_list
        check_git
        check_packages ca-certificates
        version_list="$(git ls-remote --tags https://github.com/dagger/dagger | grep -oP "sdk/cue/v\K[0-9]+\\.[0-9]+\\.[0-9]+" | tr -d ' ' | sort -rV)"
        if [ "${requested_version}" = "latest" ] || [ "${requested_version}" = "current" ] || [ "${requested_version}" = "lts" ]; then
            declare -g "${variable_name}"="$(echo "${version_list}" | head -n 1)"
        else
            set +e
            declare -g "${variable_name}"="$(echo "${version_list}" | grep -E -m 1 "^${requested_version//./\\.}([\\.\\s]|$)")"
            set -e
        fi
    fi
    if [ -z "${!variable_name}" ] || ! echo "${version_list}" | grep "^${!variable_name//./\\.}$" >/dev/null 2>&1; then
        echo -e "Invalid ${variable_name} value: ${requested_version}\nValid values:\n${version_list}" >&2
        exit 1
    fi
    echo "${variable_name}=${!variable_name}"
}

find_version_from_git_tags DAGGER_VERSION

export DEBIAN_FRONTEND=noninteractive

check_packages curl ca-certificates
echo "Downloading dagger..."

cd /usr/local
curl -L https://dl.dagger.io/dagger-cue/install.sh | VERSION="${DAGGER_VERSION}" sh

dagger-cue version

# Clean up
cleanup

echo "Done!"
