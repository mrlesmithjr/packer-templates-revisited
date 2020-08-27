#!/usr/bin/env bash
set -e

PROJ_ROOT="$(PWD)"

cd "$PROJ_ROOT/CentOS"
packer validate -syntax-only centos7.json
packer validate -syntax-only centos8.json

cd "$PROJ_ROOT/Debian"
packer validate -syntax-only debian-buster64.json
packer validate -syntax-only debian-stretch64.json

cd "$PROJ_ROOT/Fedora"
packer validate -syntax-only fedora32.json

cd "$PROJ_ROOT/Ubuntu"
packer validate -syntax-only ubuntu-bionic64.json
packer validate -syntax-only ubuntu-xenial64.json
packer validate -syntax-only ubuntu-focal64.json

cd "$PROJ_ROOT/CentOS"
packer build -except vsphere-iso -except qemu -except virtualbox-ovf -except vmware-vmx centos7.json
packer build -only qemu centos7.json
packer build -only virtualbox-iso -only vmware-iso centos8.json
packer build -except vsphere-iso -except qemu -except virtualbox-ovf -except vmware-vmx centos8.json
packer build -only qemu centos8.json

cd "$PROJ_ROOT/Debian"
packer build -except vsphere-iso -except qemu -except virtualbox-ovf -except vmware-vmx debian-buster64.json
packer build -only qemu debian-buster64.json
packer build -except vsphere-iso -except qemu -except virtualbox-ovf -except vmware-vmx debian-stretch64.json
packer build -only qemu debian-stretch64.json

cd "$PROJ_ROOT/Fedora"
packer build -except vsphere-iso -except qemu -except virtualbox-ovf -except vmware-vmx fedora32.json
packer build -only qemu fedora32.json

cd "$PROJ_ROOT/Ubuntu"
packer build -except vsphere-iso -except qemu -except virtualbox-ovf -except vmware-vmx ubuntu-bionic64.json
packer build -only qemu ubuntu-bionic64.json
packer build -except vsphere-iso -except qemu -except virtualbox-ovf -except vmware-vmx ubuntu-xenial64.json
packer build -only qemu ubuntu-xenial64.json
packer build -except vsphere-iso -except qemu -except virtualbox-ovf -except vmware-vmx ubuntu-focal64.json
packer build -only qemu ubuntu-focal64.json
