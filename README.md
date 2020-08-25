# Packer Templates Revisited

After many years of maintaining my original [Packer-Templates](https://github.com/mrlesmithjr/packer-templates)
project. I've decided to bring my Packer templates into an even more consumable
format. Hence this project.

## Distros

The following table represents all distros including versions and builders
supported.

| Distro   | Version   | Template                       | Builder                                                                            |
| -------- | :-------- | :----------------------------- | :--------------------------------------------------------------------------------- |
| `Debian` | `Buster`  | `Debian/debian-buster64.json`  | `qemu`, `proxmox`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vsphere-iso` |
| `Debian` | `Stretch` | `Debian/debian-stretch64.json` | `qemu`, `proxmox`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vsphere-iso` |
| `Ubuntu` | `Bionic`  | `Ubuntu/ubuntu-bionic64.json`  | `qemu`, `proxmox`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vsphere-iso` |
| `Ubuntu` | `Focal`   | `Ubuntu/ubuntu-focal64.json`   | `qemu`, `proxmox`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vsphere-iso` |
| `Ubuntu` | `Xenial`  | `Ubuntu/ubuntu-xenial64.json`  | `qemu`, `proxmox`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vsphere-iso` |

## Usage

Using the table from above:

1. Find the `Distro`
1. Find the `Version`
1. Find the `Template`
1. Find the `Builder`

Once you've chosen the information from above, you can then build the respective
image.

We will use `Ubuntu Bionic` for the example using the `virtualbox-iso` builder.

```bash
cd Ubuntu
packer build -only virtualbox-iso ubuntu-bionic64.json
```

## Builders

### proxmox

In order to build Proxmox images, do the following:

> NOTE: Replace values which represent your environment.

```bash
export PROXMOX_NODE=pve-02
export PROXMOX_PASSWORD=packer
export PROXMOX_URL=https://192.168.2.22:8006/api2/json
export PROXMOX_USER=root@pam
```

### qemu

In order to leverage the proper acceleration for QEMU builds, do the following:

Linux hosts:

```bash
export QEMU_ACCEL=kvm
```

macOS hosts:

```bash
export QEMU_ACCEL=hvf
```

### virtualbox-iso

### virtualbox-ovf

To properly use the `virtualbox-ovf` builder, you **must** first build a
`virtualbox-iso` image.

Example usage:

```bash
packer build -only virtualbox-iso distro-version.json
```

### vmware-iso

### vsphere-iso

In order to build vSphere images, do the following:

> NOTE: Replace values which represent your environment.

```bash
export VSPHERE_CLUSTER=Compute
export VSPHERE_DATACENTER=ATL
export VSPHERE_DATASTORE=Datastore
export VSPHERE_FOLDER=Templates
export VSPHERE_NETWORK=Default
export VSPHERE_PASSWORD=VMw@re!
export VSPHERE_USERNAME=administrator@vsphere.local
export VSPHERE_VCENTER_SERVER=vcenter.local
```

## Provisioners

Ansible will be used for all provisioning of these Packer templates. Whereas,
previously it was a mixture of `Shell` and `PowerShell` scripts.

## Post-Processors

### Vagrant

### Vagrant Cloud

To properly upload to Vagrant cloud, do the following:

```bash
export VAGRANT_CLOUD_TOKEN=yourapitoken
export VAGRANT_CLOUD_USER=yourusername
```

### Manifest

## License

MIT

## Author Information

Larry Smith Jr.

- [@mrlesmithjr](https://twitter.com/mrlesmithjr)
- [mrlesmithjr@gmail.com](mailto:mrlesmithjr@gmail.com)
- [http://everythingshouldbevirtual.com](http://everythingshouldbevirtual.com)
