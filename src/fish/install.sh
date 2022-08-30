#!/usr/bin/env bash

echo "Activating fist ..."

PURE=${PURE:-true}

echo "Installing fish shell..."
if grep -q 'Ubuntu' < /etc/os-release; then
    check_packages software-properties-common
    apt-add-repository -y ppa:fish-shell/release-3
    apt-get update
    apt-get -y install --no-install-recommends fish
elif grep -q 'Debian' < /etc/os-release; then
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