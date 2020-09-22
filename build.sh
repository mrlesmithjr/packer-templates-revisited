#!/usr/bin/env bash
set -e

PROJ_ROOT="$(pwd)"

cd "$PROJ_ROOT/Arch"
packer validate -syntax-only arch.json

cd "$PROJ_ROOT/CentOS"
packer validate -syntax-only centos7.json
packer validate -syntax-only centos7-desktop.json
packer validate -syntax-only centos8.json

cd "$PROJ_ROOT/Debian"
packer validate -syntax-only debian-buster64.json
packer validate -syntax-only debian-stretch64.json

cd "$PROJ_ROOT/Fedora"
packer validate -syntax-only fedora31.json
packer validate -syntax-only fedora32.json

cd "$PROJ_ROOT/Ubuntu"
packer validate -syntax-only ubuntu-bionic64.json
packer validate -syntax-only ubuntu-bionic64-desktop.json
packer validate -syntax-only ubuntu-xenial64.json
packer validate -syntax-only ubuntu-focal64.json
packer validate -syntax-only ubuntu-focal64-desktop.json

## Servers ##

cd "$PROJ_ROOT/Arch"
packer build -only proxmox -only virtualbox-iso arch.json
packer build -only qemu arch.json

cd "$PROJ_ROOT/CentOS"
packer build -only proxmox -only virtualbox-iso -only vmware-iso centos7.json
packer build -only qemu centos7.json
packer build -only proxmox -only virtualbox-iso -only vmware-iso centos8.json
packer build -only qemu centos8.json

cd "$PROJ_ROOT/Debian"
packer build -only proxmox -only virtualbox-iso -only vmware-iso debian-buster64.json
packer build -only qemu debian-buster64.json
packer build -only proxmox -only virtualbox-iso -only vmware-iso debian-stretch64.json
packer build -only qemu debian-stretch64.json

cd "$PROJ_ROOT/Fedora"
packer build -only proxmox -only virtualbox-iso -only vmware-iso fedora31.json
packer build -only qemu fedora31.json
packer build -only proxmox -only virtualbox-iso -only vmware-iso fedora32.json
packer build -only qemu fedora32.json

cd "$PROJ_ROOT/Ubuntu"
packer build -only proxmox -only virtualbox-iso -only vmware-iso ubuntu-bionic64.json
packer build -only qemu ubuntu-bionic64.json
packer build -only proxmox -only virtualbox-iso -only vmware-iso ubuntu-xenial64.json
packer build -only qemu ubuntu-xenial64.json
packer build -only proxmox -only virtualbox-iso -only vmware-iso ubuntu-focal64.json
packer build -only qemu ubuntu-focal64.json

## End of Servers ##

## Desktops ##

cd "$PROJ_ROOT/CentOS"
packer build -only virtualbox-iso -only vmware-iso centos7-desktop.json

cd "$PROJ_ROOT/Ubuntu"
packer build -only virtualbox-iso -only vmware-iso ubuntu-bionic64-desktop.json
packer build -only virtualbox-iso -only vmware-iso ubuntu-focal64-desktop.json

## End of Desktops ##
