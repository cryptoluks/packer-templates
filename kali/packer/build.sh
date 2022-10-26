#!/usr/bin/env bash
\rm kali.box
vboxmanage unregistervm --delete kali
set -e
packer build -force .
