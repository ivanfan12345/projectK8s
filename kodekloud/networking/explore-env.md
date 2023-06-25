1. How many nodes are part of this cluster?

    `k get no`

2. What is the Internal IP address of the controlplane node in this cluster?

    `k get no -owide`

3. What is the network interface configured for cluster connectivity on the controlplane node. node-to-node communication

    `ifconfig` or Run the `ip a` / `ip link` command and identify the interface.

4. What is the MAC address of the interface on the controlplane node?

    `if config` or `ip link show eth0`

5. What is the IP address assigned to node01?

    `k get no -owide`

6. What is the MAC address assigned to node01?

    `if config` or `ip link show eth0`

7. We use Containerd as our container runtime. What is the interface/bridge created by Containerd on the controlplane node?

    Run the command: ip link and look for a bridge interface created by containerd.

8. What is the state of the interface cni0?

    Run the command: ip link show cni0 and look for the state.

9. If you were to ping google from the controlplane node, which route does it take? What is the IP address of the Default Gateway?

    Run the command: ip route show default and look at for default gateway.

10. What is the port the kube-scheduler is listening on in the controlplane node?

    Here is a sample result of using the netstat command and searching for the scheduler process:
    ```
    root@controlplane:~# netstat -nplt | grep scheduler
    tcp        0      0 127.0.0.1:10259         0.0.0.0:*               LISTEN      3665/kube-scheduler 
    root@controlplane:~# 
    ```
    We can see that the kube-scheduler process binds to the port 10259 on the controlplane node.

11. Notice that ETCD is listening on two ports. Which of these have more client connections established?

    `netstat -anp | grep etcd`

    Here is a sample result:
    ```
    root@controlplane:~# netstat -anp | grep etcd | grep 2380 | wc -l 
    1
    root@controlplane:~# 
    root@controlplane:~# 
    root@controlplane:~# netstat -anp | grep etcd | grep 2379 | wc -l 
    81
    root@controlplane:~# 
    ```
    Important Note The count you see in this example may change for your lab, so make sure to check for yourself.

12. Correct! That's because 2379 is the port of ETCD to which all control plane components connect to. 2380 is only for etcd peer-to-peer connectivity. When you have multiple controlplane nodes. In this case we don't.