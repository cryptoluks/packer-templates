packer {
  required_plugins {
    windows-update = {
      version = "0.14.0"
      source  = "github.com/rgl/windows-update"
    }
  }
}

source "virtualbox-vm" "windows-updates2" {
  guest_additions_mode  = "disable"
  headless              = true
  shutdown_command      = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
  ssh_password          = "vagrant"
  ssh_timeout           = "4h"
  ssh_username          = "vagrant"
  vm_name               = "windows"
  attach_snapshot       = "updates"
  target_snapshot       = "updates2"
  force_delete_snapshot = true
  keep_registered       = true
  skip_export           = true
}

build {

  sources = [
    "source.virtualbox-vm.windows-updates2",
  ]

  provisioner "windows-update" {
  }

}
