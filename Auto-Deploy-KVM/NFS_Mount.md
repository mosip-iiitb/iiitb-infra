# Mounting a host directory to kvm-guest machine

Here we are setting up NFS (Network File Share) for mounting the shared directories into the kvm guest machine.
**Note** : Here the host machine is on Ubuntu and the KVM guest machine is Centos  
## Setting up host machine
The first step is to install the nfs-kernel-server package on the host machine
```
$ sudo apt update
$ sudo apt install nfs-kernel-server
```
The second step will be creating a directory that will be shared among guest machines. Here I am sharing a directory present in my home directory. Since we want all the client machines to access the shared directory, remove any restrictions in the directory permissions. And change its directory permissions to according to your need.
```
$ sudo mkdir -p /home/krishna/vmshare
$ sudo chown -R nobody:nogroup /home/krishna/vmshare
$ sudo chmod 777 /home/krishna/vmshare
```

The third step would be granting NFS Share access to the guest systems so we need to modify the /etc/exports directory as follows:
```
$ cat /etc/exports 
/home/krishna/vmshare  192.168.29.247(rw,sync) 
# shared directory name   IP Address of guest machine(rw,sync)
```
where, **rw** : Stands for Read/Write, **sync** : Requires changes to be written to the disk before they are applied.
And we add any number of guest machines by specifying IP addresses of the guest machines.

Now the next Step in host system is to export the NFS share directory and restart the nfs kernel server. We can do this by running the following command.
```
$ sudo exportfs -a
$ sudo systemctl restart nfs-kernel-server
```
For the client to access the NFS share, we need to allow access through the firewall otherwise, accessing and mounting the shared directory will be impossible. Later, Reload or enable the firewall (if it was turned off) and check the status of the firewall. Port 2049, which is the default file share, should be opened.
```
$ sudo ufw allow from 192.168.29.247 to any port nfs
$ sudo ufw enable
$ sudo ufw status
```
