1. Install the kubeadm and kubelet packages on the controlplane and node01 nodes. Use the exact version of 1.27.0-00 for both.

    kubeadm installed on controlplane?
    kubelet installed on controlplane?
    Kubeadm installed on worker node01?
    Kubelet installed on worker node01?

    Refer to the official k8s documentation - https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/ and follow the installation steps.

    These steps have to be performed on both nodes.

    set net.bridge.bridge-nf-call-iptables to 1:
    ```

    cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
    br_netfilter
    EOF

    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF

    sudo sysctl --system
    ```
    The container runtime has already been installed on both nodes, so you may skip this step.
    Install kubeadm, kubectl and kubelet on all nodes:
    ```

    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl

    mkdir -p /etc/apt/keyrings

    curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg

    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

    sudo apt-get update

    sudo apt-get install -y kubelet=1.27.0-00 kubeadm=1.27.0-00 kubectl=1.27.0-00

    sudo apt-mark hold kubelet kubeadm kubectl
    ```

2. What is the version of kubelet installed?

    `kubelet --version` 

3. How many nodes are part of kubernetes cluster currently?

    `k get no`

4. Lets now bootstrap a kubernetes cluster using kubeadm.

5. Initialize Control Plane Node (Master Node). Use the following options:

    1. apiserver-advertise-address - Use the IP address allocated to eth0 on the controlplane node
    2. apiserver-cert-extra-sans - Set it to controlplane
    3. pod-network-cidr - Set to 10.244.0.0/16

    Once done, set up the default kubeconfig file and wait for node to be part of the cluster.

    run `kubeadm init --apiserver-cert-extra-sans=controlplane --apiserver-advertise-address 192.29.57.3 --pod-network-cidr=10.244.0.0/16`

    The IP address used here is just an example. It will change for your lab session. Make sure to check the IP address allocated to eth0 by running:
    ```
    root@controlplane:~# ifconfig eth0
    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1450
            inet 192.23.108.8  netmask 255.255.255.0  broadcast 192.23.108.255
            ether 02:42:c0:17:6c:08  txqueuelen 0  (Ethernet)
            RX packets 3491  bytes 466178 (466.1 KB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 3371  bytes 939716 (939.7 KB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    root@controlplane:~#
    ```
    In this example, the IP address is 192.23.108.8

    You can use the below kubeadm init command to spin up the cluster:

    ```
    IP_ADDR=$(ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    kubeadm init --apiserver-cert-extra-sans=controlplane --apiserver-advertise-address $IP_ADDR --pod-network-cidr=10.244.0.0/16
    ```
    Once you run the init command, you should see an output similar to below:


    ```
    [init] Using Kubernetes version: v1.27.2
    [preflight] Running pre-flight checks
    [preflight] Pulling images required for setting up a Kubernetes cluster
    [preflight] This might take a minute or two, depending on the speed of your internet connection
    [preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
    W0527 08:20:20.776881   17295 images.go:80] could not find officially supported version of etcd for Kubernetes v1.27.2, falling back to the nearest etcd version (3.5.7-0)
    W0527 08:20:29.514363   17295 checks.go:835] detected that the sandbox image "k8s.gcr.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
    [certs] Using certificateDir folder "/etc/kubernetes/pki"
    [certs] Generating "ca" certificate and key
    [certs] Generating "apiserver" certificate and key
    [certs] apiserver serving cert is signed for DNS names [controlplane kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.23.108.8]
    [certs] Generating "apiserver-kubelet-client" certificate and key
    [certs] Generating "front-proxy-ca" certificate and key
    [certs] Generating "front-proxy-client" certificate and key
    [certs] Generating "etcd/ca" certificate and key
    [certs] Generating "etcd/server" certificate and key
    [certs] etcd/server serving cert is signed for DNS names [controlplane localhost] and IPs [192.23.108.8 127.0.0.1 ::1]
    [certs] Generating "etcd/peer" certificate and key
    [certs] etcd/peer serving cert is signed for DNS names [controlplane localhost] and IPs [192.23.108.8 127.0.0.1 ::1]
    [certs] Generating "etcd/healthcheck-client" certificate and key
    [certs] Generating "apiserver-etcd-client" certificate and key
    [certs] Generating "sa" key and public key
    [kubeconfig] Using kubeconfig folder "/etc/kubernetes"
    [kubeconfig] Writing "admin.conf" kubeconfig file
    [kubeconfig] Writing "kubelet.conf" kubeconfig file
    [kubeconfig] Writing "controller-manager.conf" kubeconfig file
    [kubeconfig] Writing "scheduler.conf" kubeconfig file
    [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [kubelet-start] Starting the kubelet
    [control-plane] Using manifest folder "/etc/kubernetes/manifests"
    [control-plane] Creating static Pod manifest for "kube-apiserver"
    [control-plane] Creating static Pod manifest for "kube-controller-manager"
    [control-plane] Creating static Pod manifest for "kube-scheduler"
    [etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
    W0527 08:20:33.516573   17295 images.go:80] could not find officially supported version of etcd for Kubernetes v1.27.2, falling back to the nearest etcd version (3.5.7-0)
    [wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
    [apiclient] All control plane components are healthy after 12.002756 seconds
    [upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
    [kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
    [upload-certs] Skipping phase. Please see --upload-certs
    [mark-control-plane] Marking the node controlplane as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
    [mark-control-plane] Marking the node controlplane as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
    [bootstrap-token] Using token: udz7gw.ock7lve14hw0cdpp
    [bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
    [bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
    [bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
    [bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
    [bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
    [bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
    [kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
    [addons] Applied essential addon: CoreDNS
    [addons] Applied essential addon: kube-proxy

    Your Kubernetes control-plane has initialized successfully!

    To start using your cluster, you need to run the following as a regular user:

    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

    Alternatively, if you are the root user, you can run:

    export KUBECONFIG=/etc/kubernetes/admin.conf

    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
    https://kubernetes.io/docs/concepts/cluster-administration/addons/

    Then you can join any number of worker nodes by running the following on each as root:

    kubeadm join 192.23.108.8:6443 --token udz7gw.ock7lve14hw0cdpp \
            --discovery-token-ca-cert-hash sha256:e7755ede5d6f0bae08bca4e13ccce8923995245ca68bba5f7ccc53c9b9728cdb 
    ```


    Once the command has been run successfully, set up the kubeconfig:

    ```
    root@controlplane:~> mkdir -p $HOME/.kube
    root@controlplane:~> sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    root@controlplane:~> sudo chown $(id -u):$(id -g) $HOME/.kube/config
    root@controlplane:~>
    ```
6. Generate a kubeadm join token

    `kubeadm token create --print-join-command`

7. Join node01 to the cluster using the join token

    To create token:

    ```
    root@controlplane:~> kubeadm token create --print-join-command
    kubeadm join 192.23.108.8:6443 --token thubfg.2zq20f5ttooz27op --discovery-token-ca-cert-hash sha256:e7755ede5d6f0bae08bca4e13ccce8923995245ca68bba5f7ccc53c9b9728cdb  
    ```


    next, SSH to the node01 and run the join command on the terminal:
    ```

    root@node01:~> kubeadm join 192.23.108.8:6443 --token thubfg.2zq20f5ttooz27op --discovery-token-ca-cert-hash sha256:e7755ede5d6f0bae08bca4e13ccce8923995245ca68bba5f7ccc53c9b9728cdb 
    [preflight] Running pre-flight checks
    [preflight] Reading configuration from the cluster...
    [preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
    [kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
    [kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
    [kubelet-start] Starting the kubelet
    [kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

    This node has joined the cluster:
    * Certificate signing request was sent to apiserver and a response was received.
    * The Kubelet was informed of the new secure connection details.

    Run 'kubectl get nodes' on the control-plane to see this node join the cluster.
    ```

8. To install a network plugin, we will go with Flannel as the default choice. For inter-host communication, we will utilize the eth0 interface. Please ensure that the Flannel manifest includes the appropriate options for this configuration. Refer to the official documentation for the procedure.

    
    Network Plugin deployed?
    Is Flannel using "eth0" interface for inter-host communication ?

    On the controlplane node, run the following set of commands to deploy the network plugin:
    1. Download the original YAML file and save it as kube-flannel.yml:
    `curl -LO https://raw.githubusercontent.com/flannel-io/flannel/v0.20.2/Documentation/kube-flannel.yml`
    2. Open the kube-flannel.yml file using a text editor.
    3. ocate the args section within the kube-flannel container definition. It should look like this:
    ```
    args:
    - --ip-masq
    - --kube-subnet-mgr
    ```
    4. Add the additional argument - --iface=eth0 to the existing list of arguments.
    5. Now apply the modified manifest kube-flannel.yml file using kubectl:
    ```
    kubectl apply -f kube-flannel.yml
    ```
    After applying the manifest, the STATUS of both the nodes should become Ready
    ```

    controlplane ~ ➜  kubectl get nodes
    NAME           STATUS   ROLES           AGE   VERSION
    controlplane   Ready    control-plane   15m   v1.27.0
    node01         Ready    <none>          15m   v1.27.0
    ```

9.

    

10.

