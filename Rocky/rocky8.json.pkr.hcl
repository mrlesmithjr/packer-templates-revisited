# This file was autogenerated by the 'packer hcl2_upgrade' command. We
# recommend double checking that everything is correct before going forward. We
# also recommend treating this file as disposable. The HCL2 blocks in this
# file can be moved to other files. For example, the variable blocks could be
# moved to their own 'variables.pkr.hcl' file, etc. Those files need to be
# suffixed with '.pkr.hcl' to be visible to Packer. To use multiple files at
# once they also need to be in the same folder. 'packer inspect folder/'
# will describe to you what is in that folder.

# Avoid mixing go templating calls ( for example ```{{ upper(`string`) }}``` )
# and HCL2 calls (for example '${ var.string_value_example }' ). They won't be
# executed together and the outcome will be unknown.

# All generated input variables will be of 'string' type as this is how Packer JSON
# views them; you can change their type later on. Read the variables type
# constraints documentation
# https://www.packer.io/docs/templates/hcl_templates/variables#type-constraints for more info.
variable "boot_wait" {
  type    = string
  default = "10s"
}

variable "cloud_init_storage_pool" {
  type    = string
  default = "local"
}

variable "communicator" {
  type    = string
  default = "ssh"
}

variable "cpus" {
  type    = string
  default = "1"
}

variable "disk_adapter_type" {
  type    = string
  default = "sata"
}

variable "disk_size" {
  type    = string
  default = "36864"
}

variable "headless" {
  type    = string
  default = "true"
}

variable "iso_checksum" {
  type    = string
  default = "53a62a72881b931bdad6b13bcece7c3a2d4ca9c4a2f1e1a8029d081dd25ea61f"
}

variable "iso_url" {
  type    = string
  default = "https://download.rockylinux.org/pub/rocky/8/isos/x86_64/Rocky-8.4-x86_64-boot.iso"
}

variable "memory" {
  type    = string
  default = "1024"
}

variable "proxmox_disk_size" {
  type    = string
  default = "8G"
}

variable "proxmox_iso_storage_pool" {
  type    = string
  default = "ISOs"
}

variable "proxmox_network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "proxmox_node" {
  type    = string
  default = "${env("PROXMOX_NODE")}"
}

variable "proxmox_password" {
  type    = string
  default = "${env("PROXMOX_PASS")}"
}

variable "proxmox_storage_pool" {
  type    = string
  default = "local"
}

variable "proxmox_storage_pool_type" {
  type    = string
  default = "directory"
}

variable "proxmox_url" {
  type    = string
  default = "${env("PROXMOX_URL")}"
}

variable "proxmox_username" {
  type    = string
  default = "${env("PROXMOX_USER")}"
}

variable "qemu_accelerator" {
  type    = string
  default = "${env("QEMU_ACCEL")}"
}

variable "qemu_disk_cache" {
  type    = string
  default = "writeback"
}

variable "qemu_disk_format" {
  type    = string
  default = "qcow2"
}

variable "shutdown_command" {
  type    = string
  default = "echo 'packer' | sudo -S shutdown -P now"
}

variable "ssh_password" {
  type    = string
  default = "packer"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "vagrant_box_tag" {
  type    = string
  default = "${env("VAGRANT_CLOUD_USER")}/rocky8"
}

variable "vagrant_cloud_token" {
  type    = string
  default = "${env("VAGRANT_CLOUD_TOKEN")}"
}

variable "vm_name" {
  type    = string
  default = "rocky8"
}

variable "vsphere_cluster" {
  type    = string
  default = "${env("VSPHERE_CLUSTER")}"
}

variable "vsphere_datacenter" {
  type    = string
  default = "${env("VSPHERE_DATACENTER")}"
}

variable "vsphere_datastore" {
  type    = string
  default = "${env("VSPHERE_DATASTORE")}"
}

variable "vsphere_folder" {
  type    = string
  default = "${env("VSPHERE_FOLDER")}"
}

variable "vsphere_network" {
  type    = string
  default = "${env("VSPHERE_NETWORK")}"
}

variable "vsphere_password" {
  type    = string
  default = "${env("VSPHERE_PASSWORD")}"
}

variable "vsphere_username" {
  type    = string
  default = "${env("VSPHERE_USERNAME")}"
}

variable "vsphere_vcenter_server" {
  type    = string
  default = "${env("VSPHERE_VCENTER_SERVER")}"
}

# "timestamp" template function replacement
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# All locals variables are generated from variables that uses expressions
# that are not allowed in HCL2 variables.
# Read the documentation for locals blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/locals
locals {
  timestamp = "${local.timestamp}"
}

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source. Read the documentation for source blocks here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/source
source "proxmox-iso" "rocky" {
  boot_command            = ["<tab><bs><bs><bs><bs><bs>text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.8.cfg<enter><wait>"]
  boot_wait               = "${var.boot_wait}"
  cloud_init              = true
  cloud_init_storage_pool = "${var.cloud_init_storage_pool}"
  communicator            = "${var.communicator}"
  cores                   = "${var.cpus}"
  cpu_type                = "host"
  disks {
    cache_mode        = "${var.qemu_disk_cache}"
    disk_size         = "${var.proxmox_disk_size}"
    format            = "${var.qemu_disk_format}"
    storage_pool      = "${var.proxmox_storage_pool}"
    storage_pool_type = "${var.proxmox_storage_pool_type}"
    type              = "${var.disk_adapter_type}"
  }
  http_directory           = "${path.root}/../http"
  insecure_skip_tls_verify = true
  iso_checksum             = "${var.iso_checksum}"
  iso_storage_pool         = "${var.proxmox_iso_storage_pool}"
  iso_url                  = "${var.iso_url}"
  memory                   = "${var.memory}"
  network_adapters {
    bridge = "${var.proxmox_network_bridge}"
  }
  node         = "${var.proxmox_node}"
  os           = "l26"
  password     = "${var.proxmox_password}"
  proxmox_url  = "${var.proxmox_url}"
  qemu_agent   = true
  ssh_password = "${var.ssh_password}"
  ssh_timeout  = "${var.ssh_timeout}"
  ssh_username = "${var.ssh_username}"
  unmount_iso  = true
  username     = "${var.proxmox_username}"
  vm_name      = "${var.vm_name}"
}

source "qemu" "rocky" {
  accelerator      = "${var.qemu_accelerator}"
  boot_command     = ["<tab><bs><bs><bs><bs><bs>text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.8.cfg<enter><wait>"]
  boot_wait        = "${var.boot_wait}"
  communicator     = "${var.communicator}"
  cpus             = "${var.cpus}"
  disk_cache       = "${var.qemu_disk_cache}"
  disk_interface   = "virtio"
  disk_size        = "${var.disk_size}"
  format           = "${var.qemu_disk_format}"
  headless         = "${var.headless}"
  http_directory   = "${path.root}/../http"
  iso_checksum     = "${var.iso_checksum}"
  iso_url          = "${var.iso_url}"
  memory           = "${var.memory}"
  output_directory = "output-${var.vm_name}-${source.type}-${local.timestamp}"
  shutdown_command = "${var.shutdown_command}"
  ssh_password     = "${var.ssh_password}"
  ssh_timeout      = "${var.ssh_timeout}"
  ssh_username     = "${var.ssh_username}"
  vm_name          = "${var.vm_name}"
}

source "vagrant" "rocky" {
  communicator = "${var.communicator}"
  output_dir   = "output-${var.vm_name}-${source.type}-${local.timestamp}"
  provider     = "virtualbox"
  source_path  = "${var.vagrant_box_tag}"
  ssh_password = "${var.ssh_password}"
  ssh_username = "${var.ssh_username}"
}

source "virtualbox-iso" "rocky" {
  boot_command         = ["<tab><bs><bs><bs><bs><bs>text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.8.cfg<enter><wait>"]
  boot_wait            = "${var.boot_wait}"
  communicator         = "${var.communicator}"
  cpus                 = "${var.cpus}"
  disk_size            = "${var.disk_size}"
  guest_os_type        = "RedHat_64"
  hard_drive_interface = "${var.disk_adapter_type}"
  headless             = "${var.headless}"
  http_directory       = "${path.root}/../http"
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  memory               = "${var.memory}"
  output_directory     = "output-${var.vm_name}-${source.type}-${local.timestamp}"
  shutdown_command     = "${var.shutdown_command}"
  ssh_password         = "${var.ssh_password}"
  ssh_timeout          = "${var.ssh_timeout}"
  ssh_username         = "${var.ssh_username}"
  vm_name              = "${var.vm_name}"
}

source "virtualbox-ovf" "rocky" {
  boot_wait        = "${var.boot_wait}"
  communicator     = "${var.communicator}"
  headless         = "${var.headless}"
  output_directory = "output-${var.vm_name}-${source.type}-${local.timestamp}"
  shutdown_command = "${var.shutdown_command}"
  source_path      = "output-${var.vm_name}-virtualbox-iso-latest/${var.vm_name}.ovf"
  ssh_password     = "${var.ssh_password}"
  ssh_timeout      = "${var.ssh_timeout}"
  ssh_username     = "${var.ssh_username}"
}

source "vmware-iso" "rocky" {
  boot_command      = ["<tab><bs><bs><bs><bs><bs>text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.8.cfg<enter><wait>"]
  boot_wait         = "${var.boot_wait}"
  communicator      = "${var.communicator}"
  cpus              = "${var.cpus}"
  disk_adapter_type = "${var.disk_adapter_type}"
  disk_size         = "${var.disk_size}"
  disk_type_id      = 0
  guest_os_type     = "centos-64"
  headless          = "${var.headless}"
  http_directory    = "${path.root}/../http"
  iso_checksum      = "${var.iso_checksum}"
  iso_url           = "${var.iso_url}"
  memory            = "${var.memory}"
  output_directory  = "output-${var.vm_name}-${source.type}-${local.timestamp}"
  shutdown_command  = "${var.shutdown_command}"
  ssh_password      = "${var.ssh_password}"
  ssh_timeout       = "${var.ssh_timeout}"
  ssh_username      = "${var.ssh_username}"
  vm_name           = "${var.vm_name}"
  vmx_data = {
    "ethernet0.pciSlotNumber" = "32"
  }
  vmx_remove_ethernet_interfaces = true
}

source "vmware-vmx" "rocky" {
  boot_wait        = "${var.boot_wait}"
  communicator     = "${var.communicator}"
  headless         = "${var.headless}"
  output_directory = "output-${var.vm_name}-${source.type}-${local.timestamp}"
  shutdown_command = "${var.shutdown_command}"
  source_path      = "output-${var.vm_name}-vmware-iso-latest/${var.vm_name}.vmx"
  ssh_password     = "${var.ssh_password}"
  ssh_timeout      = "${var.ssh_timeout}"
  ssh_username     = "${var.ssh_username}"
}

source "vsphere-iso" "rocky" {
  CPUS                 = "${var.cpus}"
  RAM                  = "${var.memory}"
  boot_command         = ["<tab><bs><bs><bs><bs><bs>text ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/rocky/ks.8.cfg<enter><wait>"]
  boot_wait            = "${var.boot_wait}"
  cluster              = "${var.vsphere_cluster}"
  communicator         = "${var.communicator}"
  convert_to_template  = true
  datacenter           = "${var.vsphere_datacenter}"
  datastore            = "${var.vsphere_datastore}"
  disk_controller_type = "pvscsi"
  folder               = "${var.vsphere_folder}"
  guest_os_type        = "centos64Guest"
  http_directory       = "${path.root}/../http"
  insecure_connection  = true
  iso_checksum         = "${var.iso_checksum}"
  iso_url              = "${var.iso_url}"
  network_adapters {
    network      = "${var.vsphere_network}"
    network_card = "vmxnet3"
  }
  password         = "${var.vsphere_password}"
  resource_pool    = ""
  shutdown_command = "${var.shutdown_command}"
  ssh_password     = "${var.ssh_password}"
  ssh_username     = "${var.ssh_username}"
  storage {
    disk_size             = "${var.disk_size}"
    disk_thin_provisioned = true
  }
  username       = "${var.vsphere_username}"
  vcenter_server = "${var.vsphere_vcenter_server}"
  vm_name        = "${var.vm_name}"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.proxmox-iso.rocky", "source.qemu.rocky", "source.vagrant.rocky", "source.virtualbox-iso.rocky", "source.virtualbox-ovf.rocky", "source.vmware-iso.rocky", "source.vmware-vmx.rocky", "source.vsphere-iso.rocky"]

  provisioner "ansible" {
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False"]
    extra_arguments  = ["--extra-vars", "desktop=false"]
    playbook_file    = "${path.root}/../playbooks/playbook.yml"
    user             = "${var.ssh_username}"
  }

  post-processors {
    post-processor "vagrant" {
      keep_input_artifact = true
      only                = ["qemu.rocky", "virtualbox-iso.rocky", "virtualbox-ovf.rocky", "vmware-iso.rocky"]
      output              = "${var.vm_name}-${source.type}-${local.timestamp}.box"
    }
    post-processor "vagrant-cloud" {
      access_token = "${var.vagrant_cloud_token}"
      box_tag      = "${var.vagrant_box_tag}"
      only         = ["qemu.rocky", "virtualbox-iso.rocky", "virtualbox-ovf.rocky", "vmware-iso.rocky"]
      version      = "${local.timestamp}"
    }
    post-processor "manifest" {
    }
    post-processor "shell-local" {
      inline  = ["ln -nfs ${path.root}/output-${var.vm_name}-${source.type}-${local.timestamp} ${path.root}/output-${var.vm_name}-${source.type}-latest"]
      only    = ["virtualbox-iso.rocky", "vmware-iso.rocky"]
      only_on = ["darwin", "linux"]
    }
  }
}
