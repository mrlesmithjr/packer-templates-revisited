# builds/linux/rocky-9/sources.local.pkr.hcl
#
# Local hypervisor source blocks for the Rocky Linux 9 build:
#
#   source.virtualbox-iso.rocky9  -- VirtualBox ISO install
#   source.qemu.rocky9            -- QEMU/KVM ISO install
#   source.vmware-iso.rocky9      -- VMware Workstation/Fusion ISO install
#   source.proxmox-iso.rocky9     -- Proxmox VE ISO install
#
# These sources are HCL2 conversions of the existing JSON builders.
# No Content Library or clone layer; outputs are local artifacts (OVF/VMDK/
# qcow2) consumed by the chained builders in sources.chained.pkr.hcl.
#
# Argument name reference (confirmed via hcl2_upgrade against rocky8.json):
#   virtualbox-iso: cpus, memory, disk_size, guest_os_type, hard_drive_interface,
#                   headless, http_directory, output_directory, shutdown_command
#   qemu:           cpus, memory, disk_size, accelerator, disk_cache,
#                   disk_interface, format, headless, http_directory,
#                   output_directory, shutdown_command
#   vmware-iso:     cpus, memory, disk_size, guest_os_type, disk_adapter_type,
#                   disk_type_id, headless, http_directory, output_directory,
#                   shutdown_command, vmx_data, vmx_remove_ethernet_interfaces
#   proxmox-iso:    cores, memory, disks{}, network_adapters{}, node,
#                   proxmox_url, username, password, insecure_skip_tls_verify,
#                   iso_url, iso_checksum, iso_storage_pool, http_directory,
#                   cloud_init, cloud_init_storage_pool, qemu_agent

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# -----------------------------------------------------------------------------
# VirtualBox ISO
# -----------------------------------------------------------------------------

source "virtualbox-iso" "rocky9" {
  vm_name       = var.vm_name
  guest_os_type = "RedHat_64"

  # Sizing
  cpus      = var.cpu_count
  memory    = var.memory
  disk_size = var.disk_size

  # Disk interface: sata is the safe default; override to ide if needed
  hard_drive_interface = "sata"

  # Guest Additions: disable the automatic download on CI runners where the
  # VirtualBox Extension Pack is not present.
  guest_additions_mode = "disable"

  # ISO source
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # HTTP server for kickstart delivery
  http_directory = var.http_directory

  # Boot sequence (Rocky 9: append inst.ks= to GRUB2 install entry)
  boot_wait = var.boot_wait
  boot_command = [
    "<tab><bs><bs><bs><bs><bs>",
    "text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.9.cfg<enter><wait>"
  ]

  # Communicator
  communicator     = "ssh"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = var.ssh_timeout
  shutdown_command = var.shutdown_command

  headless         = var.headless
  output_directory = var.vbox_output_dir
}

# -----------------------------------------------------------------------------
# QEMU
# -----------------------------------------------------------------------------
# NOTE: accelerator = "kvm" requires KVM support on the build host (Linux with
# /dev/kvm available). macOS or Windows CI runners must set
# QEMU_ACCEL=tcg (or hvf on Apple Silicon) via the qemu_accelerator variable
# or override accelerator here.

source "qemu" "rocky9" {
  vm_name = var.vm_name

  # Sizing
  cpus      = var.cpu_count
  memory    = var.memory
  disk_size = var.disk_size

  # KVM acceleration -- requires /dev/kvm on the build host
  accelerator    = "kvm"
  disk_interface = "virtio"
  disk_cache     = "writeback"
  format         = "qcow2"

  # ISO source
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # HTTP server for kickstart delivery
  http_directory = var.http_directory

  # Boot sequence
  boot_wait = var.boot_wait
  boot_command = [
    "<tab><bs><bs><bs><bs><bs>",
    "text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.9.cfg<enter><wait>"
  ]

  # Communicator
  communicator     = "ssh"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = var.ssh_timeout
  shutdown_command = var.shutdown_command

  headless         = var.headless
  output_directory = "output-${var.vm_name}-qemu-${local.timestamp}"
}

# -----------------------------------------------------------------------------
# VMware ISO
# -----------------------------------------------------------------------------

source "vmware-iso" "rocky9" {
  vm_name       = var.vm_name
  guest_os_type = "centos-64"

  # Sizing
  cpus      = var.cpu_count
  memory    = var.memory
  disk_size = var.disk_size

  # Disk: thin SCSI; disk_type_id 0 = monolithic sparse VMDK
  disk_adapter_type = "lsilogic"
  disk_type_id      = 0

  # ISO source
  iso_url      = var.iso_url
  iso_checksum = var.iso_checksum

  # HTTP server for kickstart delivery
  http_directory = var.http_directory

  # Boot sequence
  boot_wait = var.boot_wait
  boot_command = [
    "<tab><bs><bs><bs><bs><bs>",
    "text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.9.cfg<enter><wait>"
  ]

  # Communicator
  communicator     = "ssh"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = var.ssh_timeout
  shutdown_command = var.shutdown_command

  headless = var.headless

  # VMware-specific network configuration
  vmx_data = {
    "ethernet0.pciSlotNumber" = "32"
  }
  vmx_remove_ethernet_interfaces = true

  output_directory = "output-${var.vm_name}-vmware-iso-${local.timestamp}"
}

# -----------------------------------------------------------------------------
# Proxmox ISO
# -----------------------------------------------------------------------------
# NOTE: The legacy JSON template used builder type "proxmox". The HCL2 plugin
# registers this as "proxmox-iso". The source block type below is correct for
# the hashicorp/proxmox plugin >= 1.1.0.

source "proxmox-iso" "rocky9" {
  # Connection
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  password                 = var.proxmox_password
  insecure_skip_tls_verify = var.proxmox_insecure
  node                     = var.proxmox_node

  # VM identity
  vm_name  = var.vm_name
  os       = "l26"
  cpu_type = "host"

  # Sizing
  cores  = var.cpu_count
  memory = var.memory

  # Storage
  disks {
    type         = "scsi"
    disk_size    = "${var.disk_size}M"
    storage_pool = "local"
    format       = "qcow2"
  }

  # Network
  network_adapters {
    bridge = "vmbr0"
  }

  # ISO source
  iso_url          = var.iso_url
  iso_checksum     = var.iso_checksum
  iso_storage_pool = "local"
  unmount_iso      = true

  # HTTP server for kickstart delivery
  http_directory = var.http_directory

  # Boot sequence
  boot_wait = var.boot_wait
  boot_command = [
    "<tab><bs><bs><bs><bs><bs>",
    "text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.9.cfg<enter><wait>"
  ]

  # QEMU agent and cloud-init
  qemu_agent              = true
  cloud_init              = true
  cloud_init_storage_pool = "local"

  # Communicator
  communicator = "ssh"
  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = var.ssh_timeout
}
