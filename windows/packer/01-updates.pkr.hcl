variable "iso_checksum" {
  type    = string
  default = "sha256:668fe1af70c2f7416328aee3a0bb066b12dc6bbd2576f40f812b95741e18bc3a"
}

variable "iso_url" {
  type    = string
  default = "https://software-download.microsoft.com/download/sg/17763.107.101029-1455.rs5_release_svc_refresh_CLIENT_LTSC_EVAL_x64FRE_en-us.iso"
}

packer {
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source  = "github.com/rgl/windows-update"
    }
  }
}

source "virtualbox-iso" "windows-updates" {
  boot_command = ["<up><wait><up><wait><up><wait><up><wait><up><wait><up><wait><up><wait><up><wait><up><wait><up><wait>"]
  boot_wait    = "3s"
  cd_files = [
    "cd/autounattend.xml",
    "cd/openssh.ps1",
    "cd/powershell.ps1",
  ]
  cpus                      = 2
  disk_size                 = 61440
  firmware                  = "efi"
  gfx_controller            = "vboxsvga"
  gfx_vram_size             = 128
  guest_additions_interface = "sata"
  guest_additions_mode      = "disable"
  guest_os_type             = "Windows10_64"
  hard_drive_interface      = "sata"
  hard_drive_nonrotational  = true
  keep_registered           = true
  skip_export               = true
  headless                  = true
  iso_checksum              = var.iso_checksum
  iso_interface             = "sata"
  iso_url                   = var.iso_url
  memory                    = 4096
  shutdown_command          = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
  ssh_password              = "vagrant"
  ssh_timeout               = "4h"
  ssh_username              = "vagrant"
  vboxmanage = [
    ["modifyvm", "{{ .Name }}", "--clipboard-mode", "bidirectional"],
    ["modifyvm", "{{ .Name }}", "--draganddrop", "bidirectional"],
    ["storagectl", "{{ .Name }}", "--name", "IDE Controller", "--remove"],
  ]
  vm_name = "windows"
  vboxmanage_post = [
    ["snapshot", "{{ .Name }}", "take", "updates"],
  ]

}

build {

  sources = [
    "source.virtualbox-iso.windows-updates",
  ]

  provisioner "powershell" {
    script = "provision/disable-services.ps1"
  }

  provisioner "windows-update" {
  }

}
