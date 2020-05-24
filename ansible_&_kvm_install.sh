echo "<===========================ansible installing============================>"

sudo apt-get install software-properties-common
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt-get update
sudo apt-get -y install ansible

echo "<===========================ansible installed============================>"

echo "<=======================uncommenting host_key_checking===================>"

sed -i "/host_key_checking = False/ s/# *//"  ./ansible.cfg 

echo "<====================uncommenting host_key_checking done=================>"

echo "<========================kvm installation & bridge setup========================>"

ansible-playbook  ./ansible_playbooks/kvm_install_and_bridge_creation.yml -vvv

echo "<====================kvm installation & bridge setup done========================>"

echo "<=================restart is must to reflect the changes======================>"

echo "ENTER YOUR CHOICE Y FOR YES(RESTART IS MUST)"  
read choice

if [ "$choice" = "y" ]; then
  sudo /sbin/shutdown -r now
elif [ "$choice" = "Y" ]; then
  sudo /sbin/shutdown -r now
fi


echo "<=============================Restarting====================================>"
