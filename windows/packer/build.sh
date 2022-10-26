#!/usr/bin/env bash
\rm windows.box
vboxmanage unregistervm --delete windows
set -e
packer init 01-updates.pkr.hcl
packer build -var-file="secrets.auto.pkrvars.hcl" -force 01-updates.pkr.hcl
packer build -var-file="secrets.auto.pkrvars.hcl" -force 02-updates2.pkr.hcl
packer build -var-file="secrets.auto.pkrvars.hcl" -force 03-packages.pkr.hcl
packer build -var-file="secrets.auto.pkrvars.hcl" -force 04-optimize.pkr.hcl
