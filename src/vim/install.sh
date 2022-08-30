#!/usr/bin/env bash

echo "Activating vim ..."

PURE=${PURE:-true}

echo "Installing vim ..."

apt-get update
apt-get -y install --no-install-recommends vim

vim --version

echo "Done!"