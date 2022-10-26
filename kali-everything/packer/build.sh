#!/usr/bin/env bash
\rm kali-everything.box
vboxmanage unregistervm --delete kali-everything
set -e
packer build -force .
