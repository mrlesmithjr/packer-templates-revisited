# common/plugins.pkr.hcl
#
# Declares all Packer plugins required across the template library.
#
# Note on namespaces: the vsphere plugin transferred from HashiCorp to
# Broadcom/VMware after the provider namespace split; its source is
# github.com/vmware/vsphere. All other plugins listed here remain under
# github.com/hashicorp/.
#
# This file lives in common/ so it can be copied (or symlinked) into any
# build directory that needs the full plugin set, or referenced with
# `packer init common/` during workspace initialization.

packer {
  required_plugins {
    vsphere = {
      source  = "github.com/vmware/vsphere"
      version = ">= 2.1.2"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = ">= 1.1.1"
    }
    virtualbox = {
      source  = "github.com/hashicorp/virtualbox"
      version = ">= 1.0.5"
    }
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = ">= 1.1.0"
    }
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = ">= 1.0.11"
    }
    proxmox = {
      source  = "github.com/hashicorp/proxmox"
      version = ">= 1.1.8"
    }
    vagrant = {
      source  = "github.com/hashicorp/vagrant"
      version = ">= 1.1.4"
    }
  }
}
