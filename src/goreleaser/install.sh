#!/usr/bin/env bash

echo "Activating goreleaser ..."

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

VERSION=${VERSION:-"latest"}
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

echo "Installing goreleaser ..."

if [ "${USER}" != "root" ]; then
    sudo -u "$USER" -c "go install github.com/goreleaser/goreleaser@${VERSION}"
else
    go install github.com/goreleaser/goreleaser@"${VERSION}"
fi

goreleaser --version

echo "Done!"
