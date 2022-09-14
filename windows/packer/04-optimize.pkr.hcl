variable "access_token" {}

source "virtualbox-vm" "windows-optimize" {
  cd_files = [
    "cd/cleanmgr-settings.reg",
    "cd/policies.json",
    "cd/unattend.xml",
    "cd/rearm.ps1",
  ]
  guest_additions_interface = "sata"
  guest_additions_mode      = "disable"
  headless                  = true
  shutdown_command          = "shutdown /s /t 0 /f /d p:4:1 /c \"Packer Shutdown\""
  vm_name                   = "windows"
  force_delete_snapshot     = true
  attach_snapshot           = "packages"
  target_snapshot           = "optimize"
  ssh_password              = "vagrant"
  ssh_timeout               = "4h"
  ssh_username              = "vagrant"
}

build {

  sources = [
    "source.virtualbox-vm.windows-optimize",
  ]

  provisioner "powershell" {
    script = "provision/tweaks.ps1"
  }

  provisioner "powershell" {
    script = "provision/eject-media.ps1"
  }
  provisioner "powershell" {
    script = "provision/optimize_part1.ps1"
  }

  provisioner "windows-restart" {
  }

  provisioner "powershell" {
    script = "provision/optimize_part2.ps1"
  }

  provisioner "windows-restart" {
  }

  provisioner "powershell" {
    inline = [
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm /unattend:C:\\unattend.xml",
      "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }",
      "Remove-Item -Force C:\\unattend.xml",
    ]
  }

  post-processors {

    post-processor "vagrant" {
      vagrantfile_template = "provision/Vagrantfile.template"
    }

    post-processor "vagrant-cloud" {
      access_token = var.access_token
      box_tag      = "cryptoluks/windows"
      version      = "${formatdate("YYYY-MM-DD", timestamp())}.0.0"
    }
  }

}
