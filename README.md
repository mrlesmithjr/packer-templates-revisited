# Packer Templates Revisited

After many years of maintaining my original [Packer-Templates](https://github.com/mrlesmithjr/packer-templates)
project. I've decided to bring my Packer templates into an even more consumable
format. Hence this project.

## Distros

The following table represents all distros including versions and builders
supported.

|  Distro  |  Version  |            Template            |                                                   Builder                                                   |
| :------: | :-------: | :----------------------------: | :---------------------------------------------------------------------------------------------------------: |
| `CentOS` |    `7`    |     `CentOS/centos7.json`      | `proxmox`, `qemu`, `vagrant`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vmware-vmx`, `vsphere-iso` |
| `CentOS` |    `8`    |     `CentOS/centos8.json`      | `proxmox`, `qemu`, `vagrant`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vmware-vmx`, `vsphere-iso` |
| `Debian` | `Buster`  | `Debian/debian-buster64.json`  | `proxmox`, `qemu`, `vagrant`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vmware-vmx`, `vsphere-iso` |
| `Debian` | `Stretch` | `Debian/debian-stretch64.json` | `proxmox`, `qemu`, `vagrant`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vmware-vmx`, `vsphere-iso` |
| `Fedora` |   `32`    |     `Fedora/fedora32.json`     | `proxmox`, `qemu`, `vagrant`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vmware-vmx`, `vsphere-iso` |
| `Ubuntu` | `Bionic`  | `Ubuntu/ubuntu-bionic64.json`  | `proxmox`, `qemu`, `vagrant`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vmware-vmx`, `vsphere-iso` |
| `Ubuntu` |  `Focal`  |  `Ubuntu/ubuntu-focal64.json`  | `proxmox`, `qemu`, `vagrant`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vmware-vmx`, `vsphere-iso` |
| `Ubuntu` | `Xenial`  | `Ubuntu/ubuntu-xenial64.json`  | `proxmox`, `qemu`, `vagrant`, `virtualbox-iso`, `virtualbox-ovf`, `vmware-iso`, `vmware-vmx`, `vsphere-iso` |

> NOTE: All distros are built with `username: packer` and `password: packer`. And
> for Vagrant builds, they will also have the normal `username: vagrant` and
> `password: vagrant`.

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

> NOTE: All Proxmox builds have `cloud-init` installed and ready for usage.

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

### vagrant

> NOTE: The `vagrant` builder is currently only used for testing. So, this
> builder is excluded from Vagrant and Vagrant Cloud post-processors. The default
> provider is set as `virtualbox` as well.

The Vagrant builder is useful for testing an existing Vagrant box that has
already been published (you may want to change this).

### virtualbox-iso

### virtualbox-ovf

> NOTE: The `virtualbox-ovf` builder is currently only used for testing. So, this
> builder is excluded from Vagrant and Vagrant Cloud post-processors.

To properly use the `virtualbox-ovf` builder, you **must** first build a
`virtualbox-iso` image.

Example usage:

```bash
packer build -only virtualbox-iso distro-version.json
```

Once you have built a `virtualbox-iso`, there will be a symlink created to the
latest version built. This is the `source_path` used for the `virtualbox-ovf`
builder.

Example usage of `virtualbox-ovf`:

```bash
packer build -only virtualbox-ovf distro-version.json
```

### vmware-iso

### vmware-vmx

> NOTE: The `vmware-vmx` builder is currently only used for testing. So, this
> builder is excluded from Vagrant and Vagrant Cloud post-processors.

To properly use the `vmware-vmx` builder, you **must** first build a
`vmware-iso` image.

Example usage:

```bash
packer build -only vmware-iso distro-version.json
```

Once you have built a `vmware-iso`, there will be a symlink created to the
latest version built. This is the `source_path` used for the `vmware-vmx`
builder.

Example usage of `vmware-vmx`:

```bash
packer build -only vmware-vmx distro-version.json
```

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
