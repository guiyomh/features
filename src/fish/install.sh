#!/usr/bin/env bash

echo "Activating fist ..."

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

PURE=${PURE:-true}
USER=${2:-"automatic"}

# Determine the appropriate non-root user
if [ "${USER}" = "auto" ] || [ "${USER}" = "automatic" ]; then
    USER=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" > /dev/null 2>&1; then
            USER=${CURRENT_USER}
            break
        fi
    done
    if [ "${USER}" = "" ]; then
        USER=root
    fi
elif [ "${USER}" = "none" ] || ! id -u ${USER} > /dev/null 2>&1; then
    USER=root
fi

echo "Installing fish shell..."
if grep -q 'Debian' < /etc/os-release; then
    if grep -q 'stretch' < /etc/os-release; then
        echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_9.0/ /' | tee /etc/apt/sources.list.d/shells:fish:release:3.list
        curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_9.0/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    elif grep -q 'buster' < /etc/os-release; then
        echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' | tee /etc/apt/sources.list.d/shells:fish:release:3.list
        curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    elif grep -q 'bullseye' < /etc/os-release; then
        echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | tee /etc/apt/sources.list.d/shells:fish:release:3.list
        curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
    fi
    apt-get update
    apt-get -y install --no-install-recommends fish
fi
fish -v

echo "Installing Fisher..."
fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
if [ "${USER}" != "root" ]; then
    sudo -u "$USER" fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
fi
fish -c "fisher -v"

if [ "${PURE}" = "true" ]; then
    echo "Installing pure-fish/pure..."
    fish -c "fisher install pure-fish/pure"
    if [ "${USER}" != "root" ]; then
        sudo -u "$USER" fish -c "fisher install pure-fish/pure"
    fi
fi
echo "Done!"