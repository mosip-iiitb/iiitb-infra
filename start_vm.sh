echo "<=============changing state of all kvms from shutoff to running state=============>"
. ./env_variables/kvm_start_env_variables

for i in $(seq 1 $no_of_vm); do
virsh start $prefix_of_vm$i;
done
