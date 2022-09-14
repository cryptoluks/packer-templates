#!/usr/bin/env bash
# Ref: https://www.vagrantup.com/docs/boxes/base.html

# Add the vagrant insecure pub key
mkdir /home/vagrant/.ssh
wget -O /home/vagrant/.ssh/authorized_keys https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub
chmod 0700 /home/vagrant/.ssh/
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh/

# Password-less sudo for vagrant user
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >/etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# SSH tweak
echo 'UseDNS no' >>/etc/ssh/sshd_config

# Fix the DHCP NAT
echo -e "auto eth0\niface eth0 inet dhcp" >>/etc/network/interfaces

# Fix VirtualBox EFI mode not honoring seperate Kali EFI directory
mkdir -p /boot/efi/EFI/boot
cp /boot/efi/EFI/kali/grubx64.efi /boot/efi/EFI/boot/bootx64.efi

adduser vagrant dialout

su vagrant <<"EOFVAGRANT"

curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

tee -a ~/.bashrc <<"EOF"
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

pyenv install 2.7.18
pyenv global 2.7.18

# Install requirements for badge
pip install setuptools pyserial future cryptography pyserial

EOFVAGRANT
