1. How many Nodes are part of this cluster?

    `k get no -owdie`

2. What is the Networking Solution used by this cluster?

    Check the config file located at `/etc/cni/net.d/`

3. How many weave agents/peers are deployed in this cluster?

    `k get pods -A`

4. On which nodes are the weave peers present?

    `k get pods -n kube-system -owide`

5. Identify the name of the bridge network/interface created by weave on each node.

    Run the command `ip link`.

6. What is the POD IP address range configured by weave?

    Run the command `ip addr show weave`.

7. What is the default gateway configured on the PODs scheduled on node01? Try scheduling a pod on node01 and check ip route output

    ```
    controlplane ~ ➜  ip route
    default via 172.25.0.1 dev eth1 
    10.244.0.0/16 dev weave proto kernel scope link src 10.244.0.1 
    172.25.0.0/24 dev eth1 proto kernel scope link src 172.25.0.5 
    192.21.167.0/24 dev eth0 proto kernel scope link src 192.21.167.6 

    controlplane ~ ➜  ssh node01

    root@node01 ~ ➜  ip route
    default via 172.25.0.1 dev eth1 
    10.244.0.0/16 dev weave proto kernel scope link src 10.244.192.0 
    172.25.0.0/24 dev eth1 proto kernel scope link src 172.25.0.12 
    192.21.167.0/24 dev eth0 proto kernel scope link src 192.21.167.9 
    ```