#!/bin/bash

. ./env_variables/kubernetes_env_variables

rm -rf  ./Kubernetes-setup/Ipaddress/master.txt 
rm -rf  ./Kubernetes-setup/Ipaddress/worker.txt
rm -rf  ./Kubernetes-setup/Ipaddress/kube-lb.txt
touch   ./Kubernetes-setup/Ipaddress/master.txt 
touch   ./Kubernetes-setup/Ipaddress/worker.txt
touch   ./Kubernetes-setup/Ipaddress/kube-lb.txt
rm -rf  hosts
touch hosts
m_count=$no_of_master 
w_count=$no_of_worker
l_count=0
total_count=0

if [ $m_count -gt 1 ]
then
    l_count=1
fi

for VIRTUAL_MACHINE_NAME in $(sudo virsh list --name); do
total_count=`expr $total_count + 1`
done

#m_w_count=$no_of_master+$no_of_worker

if [ $l_count -eq 0 ]; then
 
  if [ $total_count -lt $(($no_of_master+$no_of_worker)) ]
  then
    echo "the env variables details provided is not correct we cant proceed just correct the details"
    exit 1
  fi

elif [ $l_count -eq 1 ]; then

  if [ $total_count -lt $(($no_of_master+$no_of_worker+1)) ]
  then
    echo "the env variables details provided is not correct we cant proceed just correct the details"
    exit 1
  fi

fi

echo "[nodes]" >> hosts

if [ $no_of_master -ge 1  -a  $no_of_worker -ge 1 ]
then
   
for VIRTUAL_MACHINE_NAME in $(sudo virsh list --name); do

result=$(arp -an | grep $(virsh dumpxml $VIRTUAL_MACHINE_NAME | grep '<mac' | grep -o '\([0-9a-f][0-9a-f]:\)\+[0-9a-f][0-9a-f]') | grep -o '\([0-9]\{1,3\}\.\)\+[0-9]\{1,3\}')

 
if [ $m_count -gt 0 ]
then
echo $result >> ./Kubernetes-setup/Ipaddress/master.txt
echo $result ansible_connection=ssh ansible_ssh_user=root ansible_ssh_pass=admin >> hosts 
m_count=`expr $m_count - 1`
elif [ $w_count -gt 0 ] 
then
echo $result >> ./Kubernetes-setup/Ipaddress/worker.txt
echo $result ansible_connection=ssh ansible_ssh_user=root ansible_ssh_pass=admin >> hosts 
w_count=`expr $w_count - 1`
elif [ $l_count -eq 1 ]
then
echo $result >> ./Kubernetes-setup/Ipaddress/kube-lb.txt
echo $result ansible_connection=ssh ansible_ssh_user=root ansible_ssh_pass=admin >> hosts 	
l_count=0
fi
done


else
 
 echo "count of master or node entered is not valid(enter valid details)"

fi
