# builds/linux/rocky-9/sources.chained.pkr.hcl
#
# Chained builder sources for Rocky Linux 9.
#
# PATTERN: virtualbox-ovf and vmware-vmx read the artifact produced by a prior
# build (virtualbox-iso and vmware-iso respectively). In the original JSON
# templates this was expressed with a literal source_path string. In HCL2 the
# clean pattern is a local value that constructs the path from the same
# variables used by the upstream source block, making the chain robust to
# vm_name or output directory changes.
#
# INVOCATION ORDER (important -- HCL2 has no explicit build depends_on):
#
#   Step 1 -- run the ISO builds to produce the artifacts:
#     packer build -only="local.virtualbox-iso.rocky9" .
#     packer build -only="local.vmware-iso.rocky9" .
#
#   Step 2 -- run the chained builds against the Step 1 artifacts:
#     packer build -only="local.virtualbox-ovf.rocky9-ovf" .
#     packer build -only="local.vmware-vmx.rocky9-vmx" .
#
# In CI pipelines, model Step 1 and Step 2 as separate pipeline stages with
# an explicit dependency edge between them. Do not run all sources in a single
# `packer build .` invocation -- the OVF/VMX sources will fail if the ISO
# build artifacts are not present.
#
# Argument name reference (confirmed via hcl2_upgrade against rocky8.json):
#   virtualbox-ovf: source_path, headless, output_directory, communicator,
#                   ssh_username, ssh_password, ssh_timeout, shutdown_command,
#                   boot_wait
#   vmware-vmx:     source_path, headless, output_directory, communicator,
#                   ssh_username, ssh_password, ssh_timeout, shutdown_command,
#                   boot_wait

locals {
  # Path to the OVF file produced by source.virtualbox-iso.rocky9.
  # vbox_output_dir is set in rocky-9.auto.pkrvars.hcl and matches the
  # output_directory of source.virtualbox-iso.rocky9 in sources.local.pkr.hcl.
  vbox_ovf_source = "${var.vbox_output_dir}/${var.vm_name}.ovf"

  # Path to the VMX file produced by source.vmware-iso.rocky9.
  # The output_directory in sources.local.pkr.hcl embeds local.timestamp,
  # so a stable symlink (created by the shell-local post-processor) is needed.
  # The path below references the symlink created by the shell-local
  # post-processor: output-<vm_name>-vmware-iso-latest.
  vmx_source = "output-${var.vm_name}-vmware-iso-latest/${var.vm_name}.vmx"
}

# -----------------------------------------------------------------------------
# VirtualBox OVF (chained from virtualbox-iso)
# -----------------------------------------------------------------------------

source "virtualbox-ovf" "rocky9-ovf" {
  source_path = local.vbox_ovf_source

  # Communicator
  communicator     = "ssh"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = var.ssh_timeout
  shutdown_command = var.shutdown_command

  headless         = var.headless
  boot_wait        = var.boot_wait
  output_directory = "output-${var.vm_name}-virtualbox-ovf"
}

# -----------------------------------------------------------------------------
# VMware VMX (chained from vmware-iso)
# -----------------------------------------------------------------------------

source "vmware-vmx" "rocky9-vmx" {
  source_path = local.vmx_source

  # Communicator
  communicator     = "ssh"
  ssh_username     = var.ssh_username
  ssh_password     = var.ssh_password
  ssh_timeout      = var.ssh_timeout
  shutdown_command = var.shutdown_command

  headless         = var.headless
  boot_wait        = var.boot_wait
  output_directory = "output-${var.vm_name}-vmware-vmx"
}
