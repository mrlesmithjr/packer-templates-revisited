# builds/linux/rocky-9/variables.pkr.hcl
#
# All input variables for the Rocky Linux 9 build.
# Sensitive variables are marked sensitive = true so Packer redacts them
# from logs.
#
# Connection credentials default to environment variables so CI pipelines
# can inject them without touching any file. Non-secret build parameters
# are set in rocky-9.auto.pkrvars.hcl and can be overridden on the CLI.

# -----------------------------------------------------------------------------
# vSphere connection
# -----------------------------------------------------------------------------

variable "vcenter_server" {
  type        = string
  default     = env("VSPHERE_SERVER")
  description = "vCenter FQDN or IP address"
}

variable "vcenter_username" {
  type        = string
  default     = env("VSPHERE_USERNAME")
  description = "vCenter service account username"
}

variable "vcenter_password" {
  type        = string
  sensitive   = true
  default     = env("VSPHERE_PASSWORD")
  description = "vCenter service account password"
}

variable "vcenter_insecure" {
  type        = bool
  default     = false
  description = "Set true to skip TLS certificate verification (dev/lab only)"
}

# -----------------------------------------------------------------------------
# vSphere placement
# -----------------------------------------------------------------------------

variable "datacenter" {
  type    = string
  default = env("VSPHERE_DATACENTER")
}

variable "cluster" {
  type    = string
  default = env("VSPHERE_CLUSTER")
}

variable "datastore" {
  type    = string
  default = env("VSPHERE_DATASTORE")
}

variable "network" {
  type    = string
  default = env("VSPHERE_NETWORK")
}

variable "folder" {
  type    = string
  default = env("VSPHERE_FOLDER")
}

# -----------------------------------------------------------------------------
# Content Library
# -----------------------------------------------------------------------------

variable "content_library" {
  type        = string
  default     = env("VSPHERE_CONTENT_LIBRARY")
  description = "Target vSphere Content Library name"
}

variable "content_library_item" {
  type        = string
  default     = "rocky-9-base"
  description = "Library item name. Static -- downstream consumers reference this name to find the latest published template."
}

# -----------------------------------------------------------------------------
# VM sizing (shared across all builders)
# -----------------------------------------------------------------------------

variable "vm_name" {
  type    = string
  default = "rocky-9-base"
}

variable "cpu_count" {
  type    = number
  default = 2
}

variable "memory" {
  type        = number
  default     = 2048
  description = "RAM in MB"
}

variable "disk_size" {
  type        = number
  default     = 40960
  description = "Boot disk size in MB"
}

# -----------------------------------------------------------------------------
# OS installation
# -----------------------------------------------------------------------------

variable "iso_url" {
  type    = string
  default = ""
}

variable "iso_checksum" {
  type    = string
  default = ""
}

variable "http_directory" {
  type        = string
  default     = "data"
  description = "Directory served by Packer's built-in HTTP server for kickstart files"
}

variable "boot_wait" {
  type        = string
  default     = "5s"
  description = "Time to wait after VM boot before sending boot commands"
}

variable "ssh_username" {
  type    = string
  default = "packer"
}

variable "ssh_password" {
  type      = string
  sensitive = true
  default   = "packer"
}

variable "ssh_timeout" {
  type    = string
  default = "60m"
}

variable "shutdown_command" {
  type    = string
  default = "echo 'packer' | sudo -S shutdown -P now"
}

variable "headless" {
  type        = bool
  default     = true
  description = "Run VM without a display (required for CI)"
}

# -----------------------------------------------------------------------------
# VirtualBox-specific
# -----------------------------------------------------------------------------

variable "vbox_output_dir" {
  type        = string
  default     = "output-rocky-9-virtualbox-iso"
  description = "Output directory for the virtualbox-iso build. The virtualbox-ovf chained build reads from this path."
}

# -----------------------------------------------------------------------------
# Proxmox connection
# -----------------------------------------------------------------------------

variable "proxmox_url" {
  type    = string
  default = env("PROXMOX_URL")
}

variable "proxmox_username" {
  type    = string
  default = env("PROXMOX_USERNAME")
}

variable "proxmox_password" {
  type      = string
  sensitive = true
  default   = env("PROXMOX_PASSWORD")
}

variable "proxmox_node" {
  type    = string
  default = env("PROXMOX_NODE")
}

variable "proxmox_insecure" {
  type    = bool
  default = false
}

# -----------------------------------------------------------------------------
# Vagrant
# -----------------------------------------------------------------------------

variable "vagrant_box_tag" {
  type        = string
  default     = env("VAGRANT_CLOUD_USER")
  description = "Vagrant Cloud box tag, e.g. myorg/rocky-9"
}

variable "vagrant_cloud_token" {
  type      = string
  sensitive = true
  default   = env("VAGRANT_CLOUD_TOKEN")
}
