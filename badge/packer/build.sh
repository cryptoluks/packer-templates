#!/usr/bin/env bash
\rm badge.box
vboxmanage unregistervm --delete badge
set -e
packer build -force .
