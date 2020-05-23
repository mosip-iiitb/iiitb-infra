echo "<============ssh into all kvm(centos user) from host server===========>"
ansible-playbook -i hosts ./ansible_playbooks/pre_kuber_ssh_generate.yml

echo "<============ssh from first master node to all other nodes============>"
ansible-playbook -i hosts ./ansible_playbooks/kuber_ssh_key_setup.yml 


echo "<============restrict the root login in all kvm============>"
ansible-playbook -i hosts ./ansible_playbooks/post_kuber_ssh_generate.yml
