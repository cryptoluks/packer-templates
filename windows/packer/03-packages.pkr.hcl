source "virtualbox-vm" "windows-packages" {
  guest_additions_interface = "sata"
  guest_additions_mode      = "attach"
  guest_additions_url       = "https://download.virtualbox.org/virtualbox/6.1.40/VBoxGuestAdditions_6.1.40.iso"
  headless                  = true
  shutdown_command          = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
  ssh_password              = "vagrant"
  ssh_timeout               = "4h"
  ssh_username              = "vagrant"
  vm_name                   = "windows"
  attach_snapshot           = "updates2"
  target_snapshot           = "packages"
  force_delete_snapshot     = true
  keep_registered           = true
  skip_export               = true
}

build {

  sources = [
    "source.virtualbox-vm.windows-packages",
  ]

  provisioner "powershell" {
    script = "provision/packages.ps1"
  }

}
