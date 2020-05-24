
#............Gets the host ip address............
hostIp=$(hostname -I | awk '{print $1}')


#............Copying updated ks.cfg in apache server............ 

cp ks.cfg /var/www/html/install/ks.cfg

#............Restart the apache server............
systemctl restart apache2


#............Taking the inputs from command line for #VMs, VM prefix name and hardware configuration file path............

number_of_vms=$1
vm_prefix_name=$2
hw_cfg_file_path=$3

#............Validation for command line arguments............

if [ ! $# -eq 3 ]
then
	echo "Provide all inputs needed."
	echo "Syntax: sh install_vm.sh <NumberOfVMS> <PrefixNameForVM> <VM-Hardware-config-file-path>"
	exit
fi

#............Checking whether hardware config file path is valid or not............

if [ ! -e $hw_cfg_file_path ]
then
	echo "Provide the correct path for vm hardware configuration file."$#
	exit
fi

#............Fetching the hardware configuration from the configuration file............

CPUS=$( egrep "<CPUS>" $hw_cfg_file_path | awk '{ print $2 }')
RAM=$( egrep "<RAM>" $hw_cfg_file_path | awk '{ print $2 }')
SIZE=$( egrep "<SIZE>" $hw_cfg_file_path | awk '{ print $2 }')
ISO_PATH=$( egrep "<ISO_PATH>" $hw_cfg_file_path | awk '{ print $2 }')

VM_NAME=$vm_prefix_name"1"
IMAGE_FORMAT=".qcow2"

#............Validates the location of .iso file............

if [ ! -e $ISO_PATH ]
then
	echo "Provide the location of iso file."
	exit
fi

#............Virtual machine installation............

iterate=0
while [ $iterate -lt $number_of_vms ]
do
        iterate=`expr $iterate + 1`
	virt-install  	--network bridge:virbr0 \
			--name $vm_prefix_name$iterate \
			--os-variant=centos7.0 \
			--ram=$RAM \
			--vcpus=$CPUS  \
 			--disk path=/var/lib/libvirt/images/$vm_prefix_name$iterate$IMAGE_FORMAT,format=qcow2,bus=virtio,size=$SIZE \
  			--graphics none \
		      	--location=$ISO_PATH \
  			--extra-args="console=tty0 console=ttyS0,115200"  -x ks=http://$hostIp/install/ks.cfg \
			--noautoconsole \
			--check all=off 
done
