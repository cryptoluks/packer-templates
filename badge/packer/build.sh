#!/usr/bin/env bash
vboxmanage unregistervm --delete badge
set -e
packer build -force .
