commit 02dcc4ba73a7d1f79ea3917b356d0b892a29154c
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Wed Aug 26 19:44:47 2020 -0400

    Tweaked file/folder cleanup
    
    Was too agressive before and causing builders to hang

commit 8dd8cdaf5cd649df3ba45713777d27a504d2d1f0
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Wed Aug 26 19:44:02 2020 -0400

    Added vmware-vmx builder
    
    This will allow us to test only

commit 720932079abebde8b8a85700433a7bd152594075
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Wed Aug 26 12:26:45 2020 -0400

    Added note for virtualbox-ovf builder
    
    - Only used for testing

commit c8867394401ece8dff20177fc25d7650d4ea08a0
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Wed Aug 26 12:23:31 2020 -0400

    Changes for virtualbox-ovf builder
    
    Because the current usage of virtualbox-ovf builder is for testing, we
    will exclude this builder from Vagrant and Vagrant Cloud
    post-processors.

commit 57e25ef8d836529f0573e9208f69f5b2a76fc662
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Wed Aug 26 12:22:19 2020 -0400

    More playbook tweaking
    
    As I test more on different distros, the playbooks are getting tweaked for efficiency

commit 49b32f950494905d123947d07b3df024301017dc
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Wed Aug 26 10:48:26 2020 -0400

    Added CentOS 8 support

commit 6a3ce00f8d785cf77539949f4ca3101c8ce2b439
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Wed Aug 26 10:47:56 2020 -0400

    Removed lingering packages that aren't needed in base image

commit 8422fcdce68757a1580ad7d0e0cd5db9ac85bc8d
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Wed Aug 26 02:18:43 2020 -0400

    Playbooks tweaks after further testing

commit a69ff3299a22b399c021db59b1d6451771ed92a3
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 22:00:54 2020 -0400

    Fixed boot wait time for QEMU
    
    - Ubuntu Focal boot wait time needs to be on point for each builder

commit 9ba5d23f65568fc83b1528cea171c688ef597401
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 19:45:51 2020 -0400

    Changed CentOS to sata from scsi
    
    This is an issue that has existed for a while. I
    wanted to test this using SCSI again, but....
    Will need to change to virtio for Proxmox/QEMU. PVSCSI for vSphere.

commit 0d077663b46b5d41afd91cb1f50923481eca3a72
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 19:43:07 2020 -0400

    Fixed typo in when condition to check version

commit 4443b3d61d0d3a10be26f0243d88ba79a5f29e7a
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 17:29:45 2020 -0400

    Changes for virtualbox-ovf builder
    
    - This is the first phase into a simplistic way to use this builder
    - When building for virtualbox-iso and on macOS/Linux, a symlink is created
    which points to the latest build
    - Windows support will need to be added if needed

commit 773c3aaaa41a48f702998663f453120fcf96cd22
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 17:26:57 2020 -0400

    Added CentOS 7 Support
    
    - Also added changes found while testing CentOS
    - These changes help with Debian distros as well

commit 9bf2fe16ed75b9e900c26080efb721aa6c412af1
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 13:33:45 2020 -0400

    Added Ubuntu Focal support

commit e9591d76c5a22a01494ee010c8f6591be66b4efe
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 11:16:03 2020 -0400

    Added block to solve issues with cloud-init clean
    
    - Some versions of cloud-init do not have the clean arg
    - So, we add logic to clean up cloud-init manually when clean fails

commit 193036b297131bb6fe994cd2573df1cb8c8af5e4
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 11:15:00 2020 -0400

    Added VMX Ethernet config for vmware-iso
    
    - When using Vagrant and ethernet device is not pinned to ID 32
    and ethernet device is not removed causes issues
    - This also means that an ethernet device must be added when not using Vagrant
    - Vagrant adds an ethernet device by default

commit 7df6a8ccece3f484711f5c634abe794063dfb1bf
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 11:12:57 2020 -0400

    Added Debian Stretch support

commit 8a61473eb30ba9e4fbb87f2cc06bd33554cd37b5
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Tue Aug 25 00:59:25 2020 -0400

    Changed mode of /etc/packer_build_time
    
    Need to be able to read this as non root

commit 5650a1ea318bbaccb4da723cd1cd7bbda0b88fee
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Mon Aug 24 23:20:01 2020 -0400

    Added Debian Buster support

commit ed5a9bc49d48dfe36d612052f6626e6bee026c27
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Mon Aug 24 22:29:30 2020 -0400

    Added Ubuntu Xenial support

commit c46333e0e3a90d42b720e1b71ab9dd9ea1fdc6eb
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Mon Aug 24 22:27:01 2020 -0400

    Added output directory for applicable builders
    
    This will ensure that we can track builds and not need to force
    overwrite. This will allow us to clean up old builds when needed but at
    the same time have access to the build artifacts as needed.

commit 6490ee77787b70567aabc2094ba865390739a431
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Mon Aug 24 15:24:13 2020 -0400

    Added vsphere-iso builder for Ubuntu Bionic

commit 5dc6c7d213dd7e3604a1d752636e0a5bd33d8696
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Mon Aug 24 14:51:50 2020 -0400

    Added initial Ubuntu 18.04 support

commit a8f7e03358e541cb00f0761f0d4ce3125dcd683b
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Mon Aug 24 14:50:43 2020 -0400

    Added initial Ansible playbooks

commit 2e87b8ad00e0d36993f4970045c1af6b57ef39d6
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Mon Aug 24 14:50:21 2020 -0400

    Added Python requirements

commit 70b3f4b25375d297be50e34934f6a7f15b399b96
Author: Larry Smith Jr <mrlesmithjr@gmail.com>
Date:   Mon Aug 24 14:49:58 2020 -0400

    First commit
