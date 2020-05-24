echo "<===================================creating vm====================================>"

ansible-playbook ./ansible_playbooks/creating_vm.yml -vvv

echo "<==========================wait for 10 minutes atleast or============================>"
echo "<==========================write watch virsh list --all=============================>"
echo "<===================and wait until state of vm changes to shutoff===================>"

