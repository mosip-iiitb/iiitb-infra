# Auto installation of virtual machines

Mainly we have two scripts

1. configure_network.sh
2. install_vm.sh

**Note:** Run both scripts with sudo privileges

## Pre-requisites to run configure_network.sh

1. Install git.
2. Pull iiitb-infra repository from github.com/mosip-iiitb.
3. Connect to the internet with ethernet cable(don't use WiFi).


## configure_network.sh does the following things

1. Updates all the packages
2. Installs Apache Web server
3. Allows the HTTP/HTTPS traffic for Apache web server
4. Installs KVM
5. Configures bridge
6. Enables ipv4 forwarding
7. Restarts the system(if user needs)

## Pre-requisites to run install_run.sh

1. Create the folder called 'osmedia' and put the OS image in /osmedia folder

## How to run install_vm.sh

 **Note:** change the working directory of console to iiitb-infra/Auto-Deploy-KVM
```
sh install_vm.sh <NumberOfVMS> <PrefixNameForVM> <VM-Hardware-config-file-path>

```

### References

---

[1.bridge-utils-interfaces man page](https://manpages.debian.org/jessie/bridge-utils/bridge-utils-interfaces.5.en.html)

[2.KVM with bridge](https://wiki.ubuntu.com/KvmWithBridge)

[3.Network Connection bridge](https://help.ubuntu.com/community/NetworkConnectionBridge)

[4.Cloning a virtual machine](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/cloning-a-vm)

[5.Kickstart installations](https://docs.centos.org/en-US/centos/install-guide/Kickstart2/#sect-kickstart-syntax)

[6.Automating the installation with kickstart](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/installation_guide/sn-automating-installation)

[7.KVM Virtualization in RHEL 6 Made Easy](http://linux.dell.com/files/whitepapers/KVM_Virtualization_in_RHEL_6_made_easy.pdf)

[8.KVM Virtualization in RHEL 6 Made Easy – Part 2](http://linux.dell.com/files/whitepapers/KVM_Virtualization_in_RHEL_6_Made_Easy_Part2.pdf)

[9.SHARING FILES BETWEEN THE HOST AND ITS VIRTUAL MACHINES](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_virtualization/sharing-files-between-the-host-and-its-virtual-machines_configuring-and-managing-virtualization)
	
[10.How To Set Up an NFS Mount on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-18-04)
