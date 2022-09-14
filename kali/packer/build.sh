#!/usr/bin/env bash
vboxmanage unregistervm --delete kali
set -e
packer build -force .
