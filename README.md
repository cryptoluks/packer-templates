# Packer Templates

This repository contains packer templates, scripts and other snippets to automatically build different VirtualBox-based vagrant boxes.

## Templates

TBD

## Windows 10 LTSC Evaluation Box

### Features

- Windows updates included
- Highly space optimized, box less than 6GB (removal of optional features, cleanmgr, cleanup of WinSxS folder, and more)
- Preinstalled packages with chocolatey
  - Firefox pre-deployed with uBlock, FoxyProxy, Containers and many privacy/usability tweaks via `policies.json`
  - Git
  - Notepad++
  - IrfanView
  - Python
  - 7zip
  - Visual Studio Code
  - Sysinternal Tools
  - Wireshark
  - WinSCP
- Pre-installed VirtualBox guest additions
- Many Windows-related privacy/usability tweaks
  - Disable visual effects
  - Solid color bg and lock screen
  - Auto login
  - Disabled telemetry, smartscreen
  - Disabled soundscheme
  - Disabled energy options to prevent sleep
  - Disabled search bar, people bar and other annoying UI things
  - Disabled Windows Defender
  - Disabled automatic Windows Updates
  - and more..

### Screenshots

![image](https://user-images.githubusercontent.com/9020527/183937081-562849c4-34fa-45bc-916e-029ca9c4301a.png)

![image](https://user-images.githubusercontent.com/9020527/183937322-8f101228-477d-49c6-bedd-74be30466c19.png)

## Dependencies

- Virtual Box
- Vagrant
- Packer
- Xorriso (for building `cd_image` iso, mounted into VM during installation)

## Quick Start

If you do not want to use the pre-build boxes on [Vagrant Cloud](https://app.vagrantup.com/cryptoluks), you can build the boxes by yourself.

To do so, install the dependencies and build stages as follows, in case of the Windows box:

```
# Install Windows from evaluation ISO and install updates
packer build 01-updates.pkr.hcl

# Run updates again, useful if you want to update box at a later point of time without installing Windows and most updates again
packer build 02-updates2.pkr.hcl

# Install packages with chocolatey and VirtualBox guest additions
packer build 03-packages.pkr.hcl

# Add registry tweaks, minimize image, apply Firefox settings and more
packer build 04-optimize.pkr.hcl
```

The resulting box can be imported into Vagrant now: `vagrant box add --name windows packer_windows-optimize_virtualbox.box`.

Windows will rearm trial license to full 90 days via sysprep after first startup. The box can then be rearmed one more time before you have to recreate the virtual machine.
