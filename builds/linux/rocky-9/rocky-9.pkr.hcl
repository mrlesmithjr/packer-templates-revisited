# builds/linux/rocky-9/rocky-9.pkr.hcl
#
# Build blocks for Rocky Linux 9.
#
# Three named builds are defined:
#
#   vsphere      -- vSphere ISO install, publishes to Content Library (Layer 1)
#   vsphere-cis  -- vSphere clone of Layer 1, applies CIS hardening (Layer 2)
#   local        -- All local hypervisor ISO builds (VirtualBox, QEMU, VMware,
#                   Proxmox) run in parallel when no -only flag is given.
#
# Chained builds (virtualbox-ovf, vmware-vmx) are intentionally omitted from
# the "local" build block. They must be run separately after the ISO artifacts
# exist (see sources.chained.pkr.hcl for invocation order).
#
# Usage examples:
#   packer build -only="vsphere.*" .
#   packer build -only="local.virtualbox-iso.rocky9" .
#   packer build -only="local.qemu.rocky9" .
#   packer build -only="vsphere-cis.*" .
#
# Provisioners:
#   Phase 1 (this file): Ansible base provisioner wired in.
#   Phase 3: Hardening playbook added to vsphere-cis build.
#   Phase 5: Goss validation shell provisioner added to all builds.

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

# -----------------------------------------------------------------------------
# vSphere Layer 1: base OS install
# -----------------------------------------------------------------------------

build {
  name    = "vsphere"
  sources = ["source.vsphere-iso.rocky9"]

  provisioner "ansible" {
    playbook_file    = "${path.root}/../../playbooks/playbook.yml"
    user             = var.ssh_username
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "desktop=false"]
  }

  # Phase 5 placeholder: Goss validation
  # provisioner "shell" {
  #   script = "${path.root}/../../scripts/goss-validate.sh"
  # }

  post-processor "manifest" {}
}

# -----------------------------------------------------------------------------
# vSphere Layer 2: CIS hardening (Phase 3 -- playbook TBD)
# -----------------------------------------------------------------------------

build {
  name    = "vsphere-cis"
  sources = ["source.vsphere-clone.rocky9-cis"]

  # Phase 3: replace this placeholder with the CIS hardening playbook.
  # The expected path is builds/ansible/hardening.yml once the hardening
  # role is scaffolded in Phase 3.
  provisioner "ansible" {
    playbook_file    = "${path.root}/../../ansible/hardening.yml"
    user             = var.ssh_username
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "desktop=false"]
  }

  post-processor "manifest" {}
}

# -----------------------------------------------------------------------------
# Local hypervisors: VirtualBox, QEMU, VMware, Proxmox
# -----------------------------------------------------------------------------

build {
  name = "local"
  sources = [
    "source.virtualbox-iso.rocky9",
    "source.qemu.rocky9",
    "source.vmware-iso.rocky9",
    "source.proxmox-iso.rocky9",
  ]

  provisioner "ansible" {
    playbook_file    = "${path.root}/../../playbooks/playbook.yml"
    user             = var.ssh_username
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "desktop=false"]
  }

  # Phase 5 placeholder: Goss validation
  # provisioner "shell" {
  #   script = "${path.root}/../../scripts/goss-validate.sh"
  # }

  # Vagrant box publishing pipeline (mirrors the original JSON post-processors).
  # The shell-local post-processor creates a stable -latest symlink so the
  # chained vmware-vmx and virtualbox-ovf builds can find their source artifact.
  post-processors {
    post-processor "vagrant" {
      only                = ["local.virtualbox-iso.rocky9", "local.qemu.rocky9", "local.vmware-iso.rocky9"]
      keep_input_artifact = true
      output              = "${var.vm_name}-{{ .Provider }}-${formatdate("YYYYMMDDhhmmss", timestamp())}.box"
    }

    post-processor "vagrant-cloud" {
      only         = ["local.virtualbox-iso.rocky9", "local.qemu.rocky9", "local.vmware-iso.rocky9"]
      access_token = var.vagrant_cloud_token
      box_tag      = var.vagrant_box_tag
      version      = formatdate("YYYYMMDDhhmmss", timestamp())
    }
  }

  post-processor "manifest" {}

  # Create a stable -latest symlink for the chained OVF/VMX builds.
  post-processor "shell-local" {
    only    = ["local.virtualbox-iso.rocky9", "local.vmware-iso.rocky9"]
    only_on = ["linux", "darwin"]
    inline = [
      "ln -nfs ${path.root}/output-${var.vm_name}-${build.type}-* ${path.root}/output-${var.vm_name}-${build.type}-latest"
    ]
  }
}

# -----------------------------------------------------------------------------
# Chained builds (run separately -- see sources.chained.pkr.hcl)
# -----------------------------------------------------------------------------

build {
  name = "local-chained"
  sources = [
    "source.virtualbox-ovf.rocky9-ovf",
    "source.vmware-vmx.rocky9-vmx",
  ]

  provisioner "ansible" {
    playbook_file    = "${path.root}/../../playbooks/playbook.yml"
    user             = var.ssh_username
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "desktop=false"]
  }

  # Vagrant box publishing for chained artifacts
  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = true
      output              = "${var.vm_name}-{{ .Provider }}-${formatdate("YYYYMMDDhhmmss", timestamp())}.box"
    }

    post-processor "vagrant-cloud" {
      access_token = var.vagrant_cloud_token
      box_tag      = var.vagrant_box_tag
      version      = formatdate("YYYYMMDDhhmmss", timestamp())
    }
  }

  post-processor "manifest" {}
}
