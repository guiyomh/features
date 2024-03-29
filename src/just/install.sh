#!/usr/bin/env bash

JUST_VERSION=${VERSION:-"latest"}

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

check_git() {
    if [ ! -x "$(command -v git)" ]; then
        check_packages git
    fi
}

find_version_from_git_tags() {
    local variable_name=$1
    local requested_version=${!variable_name}
    if [ "${requested_version}" = "none" ]; then return; fi
    local repository=$2
    local prefix=${3:-"tags/v"}
    local separator=${4:-"."}
    local last_part_optional=${5:-"false"}
    if [ "$(echo "${requested_version}" | grep -o "." | wc -l)" != "2" ]; then
        local escaped_separator=${separator//./\\.}
        local last_part
        if [ "${last_part_optional}" = "true" ]; then
            last_part="(${escaped_separator}[0-9]+)*?"
        else
            last_part="${escaped_separator}[0-9]+"
        fi
        local regex="${prefix}\\K[0-9]+${escaped_separator}[0-9]+${last_part}$"
        local version_list
        check_git
        check_packages ca-certificates
        version_list="$(git ls-remote --tags "${repository}" | grep -oP "${regex}" | tr -d ' ' | tr "${separator}" "." | sort -rV)"
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

export DEBIAN_FRONTEND=noninteractive

check_packages dpkg

architecture="$(dpkg --print-architecture|grep -oP 'amd64|arm64')"
if [ "${architecture}" != "amd64" ] && [ "${architecture}" != "arm64" ]; then
    echo "(!) Architecture $architecture unsupported"
    exit 1
fi

# Soft version matching
find_version_from_git_tags JUST_VERSION "https://github.com/casey/just" "tags/"

check_packages curl ca-certificates
echo "Downloading just..."
mkdir /tmp/just
curl -sL "https://github.com/casey/just/releases/download/${JUST_VERSION}/just-${JUST_VERSION}-$(uname -m)-unknown-linux-musl.tar.gz" | tar xz -C /tmp/just
mv "/tmp/just/just" /usr/local/bin/just
mv "/tmp/just/just.1" "/usr/share/man/man1/just.1"
rm -rf /tmp/just

echo -e "\nsource <(just --completions bash)\n" >> "$_REMOTE_USER_HOME/.bashrc"

# Clean up
cleanup

echo "Done!"
