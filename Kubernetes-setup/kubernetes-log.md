# Log of Kubernetes setup.

### Resources referred
> There are multiple resources available to understand kubernetes, we have provided the resources which we thought would be necessary and useful with respect to mosip deployment.
###### Kubernetes Basics
1. https://medium.com/jorgeacetozi/kubernetes-master-components-etcd-api-server-controller-manager-and-scheduler-3a0179fc8186
2. https://medium.com/jorgeacetozi/kubernetes-node-components-service-proxy-kubelet-and-cadvisor-dcc6928ef58c
3. https://medium.com/better-programming/a-closer-look-at-etcd-the-brain-of-a-kubernetes-cluster-788c8ea759a5
###### Understanding Pods
1. https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/
2. https://kubernetes.io/docs/tasks/configure-pod-container/assign-memory-resource/
3. https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/
###### Understanding Deployments
1. https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
2. https://blog.container-solutions.com/kubernetes-deployment-strategies 
    > The above link might be little old, but one of the best blogs to understand the deployment conceptually.
###### Understanding Service
1. https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/
2. https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/
###### Kubernetes High Availability
1. https://medium.com/@dominik.tornow/kubernetes-high-availability-d2c9cbbdd864
2. https://thenewstack.io/kubernetes-high-availability-no-single-point-of-failure/
###### Creating single control plane cluster using Kubeadm
1. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
###### Creating Multi control plane cluster using Kubeadm
1. http://dockerlabs.collabnix.com/kubernetes/beginners/Install-and-configure-a-multi-master-Kubernetes-cluster-with-kubeadm.html
   > The above link is little outdated, but we have followed this link to build the multi control plane cluster using kubeadm. The changes that we made to this link are explained below. 
###### Setup.sh Script

1) Install CFSSL
2) Change the permission and move to bin folder.
3) Install kubectl. Here we are only installing kubectl, will be configured at the end to access the kubernetes cluster.
4) Create CA Certificate, using CA certificate create a self signed certificate. CA config file contains usage and expiry time for the certificate. 
5) Copy the certificates to master nodes and worker nodes.
6) Install and configure the load balancer. Here we are using haproxy as loadbalancer. sample script that will be generated and executed in the loadbalancer is shown below.
    ```
    #!/bin/sh
    apt-get update -y
    apt-get upgrade -y
    apt-get install haproxy -y
    content="
    frontend kubernetes
    bind 192.168.0.110:6443    // IP address of the load balancer
    option tcplog
    mode tcp
    default_backend kubernetes-master-nodes
    
    backend kubernetes-master-nodes
    mode tcp // Layer 4 Load balancing
    balance roundrobin // Load balancing algorithm
    option tcp-check
    server k8s-master-0 192.168.0.107:6443 check fall 3 rise 2 // First master node
    server k8s-master-1 192.168.0.108:6443 check fall 3 rise 2 // Second master node
    server k8s-master-2 192.168.0.109:6443 check fall 3 rise 2 // third master node
    "
    echo "${content}" >> /etc/haproxy/haproxy.cfg
    systemctl restart haproxy
    ```
7) Setup kubeadm in the master and worker nodes. sample script that will be generated and executed in  master node and worker node is shown below.

    ```
    #!/bin/sh
    sudo -s
    apt-get update -y
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    usermod -aG docker master1 //master1 is the hostname.
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo "deb http://apt.kubernetes.io kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
    apt-get update -y
    apt-get install kubelet kubeadm kubectl -y
    swapoff -a
    sed -i '/ swap / s/^/#/' /etc/fstab
    ```
8) Setup etcd cluster in the master nodes. sample script file containing etcd configuration that will be generated and executed is shown below.
    ```
    #!/bin/sh
    mkdir /etc/etcd /var/lib/etcd
    mv ~/ca.pem ~/kubernetes.pem ~/kubernetes-key.pem /etc/etcd
    wget https://github.com/etcd-io/etcd/releases/download/v3.3.13/etcd-v3.3.13-linux-amd64.tar.gz
    tar xvzf etcd-v3.3.13-linux-amd64.tar.gz
    mv etcd-v3.3.13-linux-amd64/etcd* /usr/local/bin/
    
    content="
    [Unit]
    Description=etcd
    Documentation=https://github.com/coreos
    
    [Service]
    ExecStart=/usr/local/bin/etcd \
      --name 192.168.0.109 \ 
      --cert-file=/etc/etcd/kubernetes.pem \
      --key-file=/etc/etcd/kubernetes-key.pem \
      --peer-cert-file=/etc/etcd/kubernetes.pem \
      --peer-key-file=/etc/etcd/kubernetes-key.pem \
      --trusted-ca-file=/etc/etcd/ca.pem \
      --peer-trusted-ca-file=/etc/etcd/ca.pem \
      --peer-client-cert-auth \
      --client-cert-auth \
      --initial-advertise-peer-urls https://192.168.0.109:2380 \
      --listen-peer-urls https://192.168.0.109:2380 \
      --listen-client-urls https://192.168.0.109:2379,http://127.0.0.1:2379 \
      --advertise-client-urls https://192.168.0.109:2379 \
      --initial-cluster-token etcd-cluster-0 \
      --initial-cluster 192.168.0.107=https://192.168.0.107:2380,192.168.0.108=https://192.168.0.108:2380,192.168.0.109=https://192.168.0.109:2380 \
      --initial-cluster-state new \
      --data-dir=/var/lib/etcd
    Restart=on-failure
    RestartSec=5
    
    [Install]
    WantedBy=multi-user.target"
    echo "${content}" > /etc/systemd/system/etcd.service
    systemctl daemon-reload
    systemctl enable etcd
    systemctl start etcd
    ```
    All the options used in etcd configuration file are explained very clearly in the official documentation of etcd. Kindly see the link: https://github.com/etcd-io/etcd/blob/master/Documentation/op-guide/configuration.md
    
9) Initialize the Kubeadm in master nodes. sample config file generated to initialize the kubeadm is as below. I have used // to comment about each line which are not part of the config file.
    ```
    apiVersion: kubeadm.k8s.io/v1beta2
    bootstrapTokens:            // Token configuration
    - groups:
      - system:bootstrappers:kubeadm:default-node-token
      token: iwken1.rdri5y93c0lerdob
      ttl: 24h0m0s
      usages:
      - signing
      - authentication
    kind: InitConfiguration
    localAPIEndpoint:
      advertiseAddress: 192.168.0.109       // Ip address of the master
      bindPort: 6443
    nodeRegistration:
      criSocket: /var/run/dockershim.sock
      name: master3
      taints:
      - effect: NoSchedule
        key: node-role.kubernetes.io/master
    ---
    apiServer:
      timeoutForControlPlane: 4m0s
      certSANs:
      - 192.168.0.110               // IP address of the Load balancer
    apiVersion: kubeadm.k8s.io/v1beta2
    certificatesDir: /etc/kubernetes/pki
    clusterName: kubernetes
    controlPlaneEndpoint: 192.168.0.110:6443   // IP address of the load balancer
    controllerManager: {}
    dns:
      type: CoreDNS
    etcd:                                     // ETCD configuration
      external:
        caFile: /etc/etcd/ca.pem
        certFile: /etc/etcd/kubernetes.pem
        endpoints:
        - https://192.168.0.107:2379
        - https://192.168.0.108:2379
        - https://192.168.0.109:2379
        keyFile: /etc/etcd/kubernetes-key.pem
    imageRepository: k8s.gcr.io
    kind: ClusterConfiguration
    kubernetesVersion: v1.18.2
    networking:
      dnsDomain: cluster.local
      podSubnet: 10.30.0.0/24
      serviceSubnet: 10.96.0.0/12
    scheduler: {}
    ```
10) Configuring the kubectl to access the master node. admin.conf file is present in all the master nodes. copying to new directory .kube so that can be accessed by kubectl when ever it commiunicates with the master nodes.

11) Deploying the overlay network. Here we are using calico, which is one of the open source container network provider. Below are few links which will help understand the kubernetes networking.
    a) https://kubernetes.io/docs/concepts/cluster-administration/networking/
    b) https://medium.com/google-cloud/understanding-kubernetes-networking-pods-7117dd28727
    c) https://neuvector.com/network-security/advanced-kubernetes-networking/
    
###### workerjoin.sh Script

1) connect to one of the master node and generate a new token
2) copy the token file to each worker node to join the cluster. 



