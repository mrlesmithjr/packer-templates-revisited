# builds/linux/rocky-9/sources.vsphere.pkr.hcl
#
# vSphere source blocks for the Rocky Linux 9 build:
#
#   source.vsphere-iso.rocky9      -- Layer 1: base OS install, published to
#                                     Content Library as an OVF item.
#   source.vsphere-clone.rocky9-cis -- Layer 2: clones the Layer 1 library item
#                                      and applies CIS hardening; published as a
#                                      separate library item.
#
# The vsphere-clone source uses a vsphere-virtualmachine data source to resolve
# the Layer 1 VM/template by name from the Content Library at build time.
#
# Argument name reference (confirmed via hcl2_upgrade against rocky8.json):
#   vcenter_server, username, password, insecure_connection
#   datacenter, cluster, datastore, folder, network (inside network_adapters block)
#   vm_name, guest_os_type
#   CPUS, RAM  (vSphere plugin uses uppercase for these two)
#   disk_controller_type  (scalar string, not a list)
#   storage { disk_size, disk_thin_provisioned }
#   network_adapters { network, network_card }
#   convert_to_template, content_library_destination { library, name, ovf }
#   http_directory, boot_command, boot_wait
#   ssh_username, ssh_password, ssh_timeout, shutdown_command
#   communicator

# -----------------------------------------------------------------------------
# Data source: resolve Layer 1 output for the clone source
# -----------------------------------------------------------------------------
# This data source looks up the VM/template published by source.vsphere-iso.rocky9
# in the Content Library by item name. The result feeds source.vsphere-clone.rocky9-cis.
#
# NOTE: vsphere-virtualmachine data source requires live vCenter connectivity at
# `packer validate` time (not -syntax-only). It will fail without credentials.

data "vsphere-virtualmachine" "rocky9-base" {
  vcenter_server = var.vcenter_server
  username       = var.vcenter_username
  password       = var.vcenter_password
  datacenter_id  = var.datacenter
  name           = var.content_library_item
}

# -----------------------------------------------------------------------------
# Layer 1: vsphere-iso -- fresh OS install published to Content Library
# -----------------------------------------------------------------------------

source "vsphere-iso" "rocky9" {
  # Connection
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = var.vcenter_insecure

  # Placement
  datacenter = var.datacenter
  cluster    = var.cluster
  datastore  = var.datastore
  folder     = var.folder

  # VM identity
  vm_name       = var.vm_name
  guest_os_type = "rhel9_64Guest"

  # Sizing (vSphere plugin uses CPUS and RAM -- uppercase)
  CPUS = var.cpu_count
  RAM  = var.memory

  # Storage
  disk_controller_type = "pvscsi"

  storage {
    disk_size             = var.disk_size
    disk_thin_provisioned = true
  }

  # Networking
  network_adapters {
    network      = var.network
    network_card = "vmxnet3"
  }

  # ISO install source
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # HTTP server for kickstart delivery
  http_directory = var.http_directory

  # Boot sequence
  # NOTE: Rocky 9 uses GRUB2; the boot command must interrupt the GRUB menu and
  # append the kickstart URL using the inst.ks= kernel argument. The exact key
  # sequence depends on the GRUB timeout and menu entry position in the ISO and
  # must be validated against a live vCenter environment before production use.
  # The placeholder below is illustrative only.
  boot_wait = var.boot_wait
  boot_command = [
    # Interrupt GRUB countdown
    "<up>",
    # Append kickstart argument to the install kernel line
    "e<down><down><end><bs><bs><bs><bs><bs>",
    "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.9.cfg<leftCtrlOn>x<leftCtrlOff>"
  ]

  # Communicator
  communicator = "ssh"
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = var.ssh_timeout

  shutdown_command = var.shutdown_command

  # Content Library publishing
  # convert_to_template must be false when content_library_destination is set.
  # destroy = true removes the ephemeral build VM after the OVF is published,
  # keeping the vSphere inventory clean.
  convert_to_template = false

  content_library_destination {
    library = var.content_library
    # Static item name: downstream consumers reference this name to pull the
    # latest published template. ovf = true overwrites the existing item
    # in-place on each run, which is the core of the recurring pipeline pattern.
    name = var.content_library_item
    ovf  = true
  }
}

# -----------------------------------------------------------------------------
# Layer 2: vsphere-clone -- CIS hardening layer
# -----------------------------------------------------------------------------
# Clones the image published by Layer 1 (resolved via data source above),
# applies CIS hardening via Ansible, and publishes a separate library item.
#
# Phase 3 will add the hardening playbook. The Ansible provisioner reference
# below points to the expected future path.

source "vsphere-clone" "rocky9-cis" {
  # Connection
  vcenter_server      = var.vcenter_server
  username            = var.vcenter_username
  password            = var.vcenter_password
  insecure_connection = var.vcenter_insecure

  # Placement
  datacenter = var.datacenter
  cluster    = var.cluster
  datastore  = var.datastore
  folder     = var.folder

  # Clone source: resolved from the Content Library item published by Layer 1
  template = data.vsphere-virtualmachine.rocky9-base.id

  # VM identity for the ephemeral clone
  vm_name = "${var.vm_name}-cis-build"

  # Communicator
  communicator = "ssh"
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = var.ssh_timeout

  shutdown_command = var.shutdown_command

  # Publish hardened image to Content Library as a separate item
  convert_to_template = false

  content_library_destination {
    library = var.content_library
    name    = "rocky-9-cis"
    ovf     = true
  }
}
