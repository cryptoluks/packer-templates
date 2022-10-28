variable "access_token" {}

variable "iso_checksum" {
  type    = string
  default = "sha256:82f702acf37771ac27355c5f9170bf365a73f0cc9e571fb422f7aa58ca218d48"
}

variable "iso_url" {
  type    = string
  default = "https://cdimage.kali.org/kali-2022.3/kali-linux-2022.3-installer-netinst-amd64.iso"
}

source "virtualbox-iso" "kali" {
  boot_command = [
    "<wait><wait><wait>c<wait><wait><wait>",
    "linux /install.amd/vmlinuz ",
    "auto=true ",
    "url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "hostname=kali ",
    "domain='' ",
    "interface=auto ",
    "vga=788 noprompt quiet --<enter>",
    "initrd /install.amd/initrd.gz<enter>",
    "boot<enter>"
  ]
  cpus                     = 2
  disk_size                = 61440
  firmware                 = "efi"
  gfx_controller           = "vmsvga"
  gfx_vram_size            = 128
  guest_additions_mode     = "disable"
  guest_os_type            = "Debian_64"
  hard_drive_interface     = "sata"
  hard_drive_nonrotational = true
  headless                 = true
  http_directory           = "http"
  iso_checksum             = var.iso_checksum
  iso_interface            = "sata"
  iso_url                  = var.iso_url
  memory                   = 4096
  shutdown_command         = "echo 'packer' | sudo -S shutdown -P now"
  ssh_password             = "vagrant"
  ssh_timeout              = "4h"
  ssh_username             = "vagrant"
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--clipboard-mode", "bidirectional"],
    ["modifyvm", "{{ .Name }}", "--draganddrop", "bidirectional"],
    ["storagectl", "{{ .Name }}", "--name", "IDE Controller", "--remove"],
  ]
  vm_name = "kali"
}

build {

  sources = [
    "source.virtualbox-iso.kali",
  ]

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S bash -euxo pipefail '{{ .Path }}'"
    scripts = [
      "provision.sh",
    ]
  }

  provisioner "shell" {
    execute_command = "echo 'vagrant' | {{ .Vars }} sudo -S bash -euxo pipefail '{{ .Path }}'"
    inline = [
      "dd if=/dev/zero of=/ZEROFILL bs=1M || true", "rm /ZEROFILL", "sync",
      "dd if=/dev/zero of=/boot/efi/ZEROFILL bs=1M || true", "rm /boot/efi/ZEROFILL", "sync",
    ]
  }

  post-processors {

    post-processor "vagrant" {
      output = "kali.box"
    }

    post-processor "vagrant-cloud" {
      access_token = var.access_token
      box_tag      = "cryptoluks/kali"
      version      = "${formatdate("YYYY-MM-DD", timestamp())}.0.0"
    }

  }

}
