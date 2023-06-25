1. What network range are the nodes in the cluster part of?

    Run the command: ip addr and look at the IP address assigned to the eth0 interfaces. Derive network range from that.

    one way to do this is to make use of the ipcalc utility. If it is not installed, you can install it by running:
    apt update and the apt install ipcalc

    Then use it to determine the network range as shown below:

    First, find the Internal IP of the nodes.
    ```
    root@controlplane:~> ip a | grep eth0
    93657: eth0@if93658: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1450 qdisc noqueue state UP group default 
        inet 10.33.39.8/24 brd 10.33.39.255 scope global eth0
    root@controlplane:~>
    ```


    Next, use the ipcalc tool to see the network details:
    ```

    root@controlplane:~> ipcalc -b 10.33.39.8
    Address:   10.33.39.8           
    Netmask:   255.255.255.0 = 24   
    Wildcard:  0.0.0.255            
    =>
    Network:   10.33.39.0/24        
    HostMin:   10.33.39.1           
    HostMax:   10.33.39.254         
    Broadcast: 10.33.39.255         
    Hosts/Net: 254                   Class A, Private Internet

    root@controlplane:~>

    ```

    In this example, the network is 10.33.39.0/24. Note, this may vary for your lab so make sure to check for yourself.



2. What is the range of IP addresses configured for PODs on this cluster?

    The network is configured with weave. Check the weave pods logs using the command kubectl logs <weave-pod-name> weave -n kube-system and look for ipalloc-range.

    ```
    controlplane ~ ➜  k logs -n kube-system weave-net-6mzk9  | grep ipalloc-range
    Defaulted container "weave" out of: weave, weave-npc, weave-init (init)
    INFO: 2023/06/25 15:25:19.617348 Command line options: map[conn-limit:200 datapath:datapath db-prefix:/weavedb/weave-net docker-api: expect-npc:true http-addr:127.0.0.1:6784 ipalloc-init:consensus=1 ipalloc-range:10.244.0.0/16 metrics-addr:0.0.0.0:6782 name:f6:21:7e:e2:7e:53 nickname:controlplane no-dns:true no-masq-local:true port:6783]
    ```

3. What is the IP Range configured for the services within the cluster?

    Inspect the setting on kube-api server by running on command `cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep cluster-ip-range`.



4. How many kube-proxy pods are deployed in this cluster?

    `kubectl get pods -n kube-system`

5. What type of proxy is the kube-proxy configured to use?

    Check the logs of the kube-proxy pods. Run the command: `kubectl logs <kube-proxy-pod-name> -n kube-system`

6. How does this Kubernetes cluster ensure that a kube-proxy pod runs on all nodes in the cluster? Inspect the kube-proxy pods and try to identify how they are deployed.

    `kubectl get ds -n kube-system`

7.
    

8.
    

9.
    

10.
    
