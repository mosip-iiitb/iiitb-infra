# IIITB-Infra (IIITB Deployment Infrastructure)

### **All the actions performed in root privileges

## Step 1: Execute ansible_&_kvm_install.sh
        After successful execution it will
       a) install ansible on host machine
       b) do host checking to false in ansible.cfg file
       c) install and configure kvm
       d) click yes for restarting the system(it is must) and after restart go to step 2.
   
   
## Step 2: Setting up Preferences.
        1.Before going to next step go to env_variables/kvm_env_variables and edit prefix(names of vm's you want to give) and number of vm's you want.
        2. And also go to env_variables/kubernetes_env_variables and give no of masters, workers you want to create.
        3. Go to env_variables/host_env_variables and enter the hostname of host server.
        4. Go to env_variables/kvm_start_env_variables and enter the number of vm's you want to start.

## Step 3: Setting up Image directory
        Make a folder named as osmedia inside Auto_Deploy_KVM and keep centos image inside that osmedia folder.
 
## Step 4: Execute create_vm.sh
        It will create n(no of vms given by user in env_variables/kvm_env_variables) number of vm's.
     
## Step 5: For confirmation of vm's creation use command: 
        $ watch virsh list --all
        This command run virsh list --all in every two seconds and it will list all your active vm's and wait until all vm's status become shutoff. After status becomes shutoff press ctrl+c.
  ##   ![running](/images/running.png)
  
  ##   ![shutoff](/images/shutoff.png)
        
## Step 6: Execute start_vm.sh
          It will start all vm's again as it will get shutoff after creation and wait for two minutes before executing fetch_ip_of_vm.sh.
   
## Step 7: Execute fetch_ip_of_vm.sh
        It will put ips of all masters and workers node in kubernetes_setup/Ipaddress text files and also in hosts text file.
       
## Step 8: Execute ssh_inside_vms.sh
        It will ssh inside all vm's which are in running state.





    
 
     
 
 
   
