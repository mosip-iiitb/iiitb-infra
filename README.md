# IIITB-Infra (IIITB Deployment Infrastructure)

### **All the actions performed in root privileges

## Step 1: Execute ansible_&_kvm_install.sh
        After successful execution it will
       a) install ansible on host machine
       b) do host checking to false in ansible.cfg file
       c) install and configure kvm
       d) click yes for restarting the system(it is must)
   
   
## Step 2: Setting up Preferences.
        Before going to next step go to env_variables/kvm_env_variables and edit prefix(names of vms you want to give) and number of vms you want.
        1. And also go to env_variables/kubernetes_env_variables and give no of masters, workers you want to create.
        2. Go to env_variables/host_env_variables and enter the name of host of host server.
        3. Go to env_variables/kvm_start_env_variables and enter the number of vms you want to start.

## Step 3: Setting up Image directory
        Make a folder named as osmedia inside Auto_Deploy_KVM and keep centos image inside that folder(osmedia).
 
## Step 4: Execute create_vm.sh
        It will create n(user given input above) number of vm's.
     
## Step 5: For confirmation of vm's creation use command: 
        $ watch virsh list --all
        It will list all your active vms and please wait until all kvms status become shutoff.
        
## Step 6: Execute start_vm.sh
          It will start all vm's again as it will get shutoff after creation and wait for two minutes before going to next  step. 
   
## Step 7: Execute fetch_ip_of_vm.sh
        It will put ips of all masters and workers node in kubernetes_setup/Ipaddress text files.
 
## Step 8: Execute ssh_inside_vms.sh
        It will ssh inside all vms which are in running state.





    
 
     
 
 
   
