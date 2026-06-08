# builds/linux/rocky-9/rocky-9.auto.pkrvars.hcl
#
# Non-secret build defaults that are auto-loaded by Packer.
# Credentials and environment-specific values (vcenter_server, datacenter,
# cluster, etc.) are NOT set here; they are read from environment variables
# as declared in variables.pkr.hcl.
#
# ISO checksum: set to "sha256:none" as a placeholder. This must be replaced
# with the current SHA-256 checksum of the Rocky 9 minimal ISO before running
# any build. Obtain the authoritative checksum from:
#   https://download.rockylinux.org/pub/rocky/9/isos/x86_64/CHECKSUM
# Example (verify before use):
#   iso_checksum = "sha256:8eb4b4e3c9fba26b47a98c98b3a4bc91bc985d97cffb046ccdea63d7e8cd0e0f"

iso_url      = "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9-latest-x86_64-minimal.iso"
iso_checksum = "sha256:none"

vm_name   = "rocky-9-base"
cpu_count = 2
memory    = 2048
disk_size = 40960
boot_wait = "10s"

ssh_username = "packer"

# VirtualBox output directory used by both the virtualbox-iso build and the
# chained virtualbox-ovf build in sources.chained.pkr.hcl.
vbox_output_dir = "output-rocky-9-virtualbox-iso"
