1. In this lab environment, you will get to work with multiple kubernetes clusters where we will practice backing up and restoring the ETCD database.


2. You will notice that, you are logged in to the student-node (instead of the controlplane). 

    The student-node has the kubectl client and has access to all the Kubernetes clusters that are configured in thie lab environment.

    Before proceeding to the next question, explore the student-node and the clusters it has access to.

    

3. How many clusters are defined in the kubeconfig on the student-node? You can make use of the kubectl config command.

    You can view the complete kubeconfig by running:

    ```
    student-node ~ ➜  kubectl config view
    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data: DATA+OMITTED
        server: https://cluster1-controlplane:6443
    name: cluster1
    - cluster:
        certificate-authority-data: DATA+OMITTED
        server: https://10.1.124.18:6443
    name: cluster2
    contexts:
    - context:
        cluster: cluster1
        user: cluster1
    name: cluster1
    - context:
        cluster: cluster2
        user: cluster2
    name: cluster2
    current-context: cluster1
    kind: Config
    preferences: {}
    users:
    - name: cluster1
    user:
        client-certificate-data: REDACTED
        client-key-data: REDACTED
    - name: cluster2
    user:
        client-certificate-data: REDACTED
        client-key-data: REDACTED
    ```

    alternatively, run the kubectl config get-clusters to just display the clusters:

    ```
    student-node ~ ➜  kubectl config get-clusters 
    NAME
    cluster1
    cluster2

    student-node ~ ➜  
    ```
4. How many nodes (both controlplane and worker) are part of cluster1? Make sure to switch the context to cluster1: `kubectl config use-context cluster1`

    `k get nodes`

5. What is the name of the controlplane node in cluster2? Make sure to switch the context to cluster2: `kubectl config use-context cluster2`

    Run the command:
    ```
    student-node ~ ➜  kubectl config use-context cluster2
    Switched to context "cluster2".

    student-node ~ ➜  kubectl get node                                                                      
    NAME                    STATUS   ROLES           AGE     VERSION
    cluster2-controlplane   Ready    control-plane   4m39s   v1.24.0
    cluster2-node01         Ready    <none>          4m3s    v1.24.0

    student-node ~ ➜  
    ```
    The name of the controlplane node is cluster2-controlplane

6. You can SSH to all the nodes (of both clusters) from the student-node.

    For example:
    ```
    student-node ~ ➜  ssh cluster1-controlplane
    Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 5.4.0-1086-gcp x86_64)

    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage
    This system has been minimized by removing packages and content that are
    not required on a system that users do not log into.

    To restore this content, you can run the 'unminimize' command.

    cluster1-controlplane ~ ➜ 
    ```
    To get back to the student node, use the logout or exit command, or, hit Control +D

    ```
    cluster1-controlplane ~ ➜  logout
    Connection to cluster1-controlplane closed.

    student-node ~ ➜  
    ```

    

7. How is ETCD configured for cluster1? Remember, you can access the clusters from student-node using the kubectl tool. You can also ssh to the cluster nodes from the student-node. Make sure to switch the context to cluster1: `kubectl config use-context cluster1`

    If you check out the pods running in the kube-system namespace in cluster1, you will notice that etcd is running as a pod:
    ```
    student-node ~ ➜  kubectl config use-context cluster1
    Switched to context "cluster1".

    student-node ~ ➜  kubectl get pods -n kube-system | grep etcd
    etcd-cluster1-controlplane                      1/1     Running   0              9m26s

    student-node ~ ➜  
    ```
    This means that ETCD is set up as a Stacked ETCD Topology where the distributed data storage cluster provided by etcd is stacked on top of the cluster formed by the nodes managed by kubeadm that run control plane components.

8. How is ETCD configured for cluster2?

    If you check out the pods running in the kube-system namespace in cluster2, you will notice that there are NO etcd pods running in this cluster!
    ```
    student-node ~ ➜  kubectl config use-context cluster2
    Switched to context "cluster2".

    student-node ~ ➜  kubectl get pods -n kube-system  | grep etcd

    student-node ~ ✖ 
    ```
    Also, there is NO static pod configuration for etcd under the static pod path:
    ```

    student-node ~ ✖ ssh cluster2-controlplane
    Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 5.4.0-1086-gcp x86_64)

    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage
    This system has been minimized by removing packages and content that are
    not required on a system that users do not log into.

    To restore this content, you can run the 'unminimize' command.
    Last login: Wed Aug 31 05:05:04 2022 from 10.1.127.14

    cluster2-controlplane ~ ➜  ls /etc/kubernetes/manifests/ | grep -i etcd

    cluster2-controlplane ~ ✖ 
    ```
    However, if you inspect the process on the controlplane for cluster2, you will see that that the process for the kube-apiserver is referencing an external etcd datastore:
    ```

    cluster2-controlplane ~ ✖ ps -ef | grep etcd
    root        1705    1320  0 05:03 ?        00:00:31 kube-apiserver --advertise-address=10.1.127.3 --allow-privileged=true --authorization-mode=Node,RBAC --client-ca-file=/etc/kubernetes/pki/ca.crt --enable-admission-plugins=NodeRestriction --enable-bootstrap-token-auth=true --etcd-cafile=/etc/kubernetes/pki/etcd/ca.pem --etcd-certfile=/etc/kubernetes/pki/etcd/etcd.pem --etcd-keyfile=/etc/kubernetes/pki/etcd/etcd-key.pem --etcd-servers=https://10.1.127.10:2379 --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key --requestheader-allowed-names=front-proxy-client --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt --requestheader-extra-headers-prefix=X-Remote-Extra- --requestheader-group-headers=X-Remote-Group --requestheader-username-headers=X-Remote-User --secure-port=6443 --service-account-issuer=https://kubernetes.default.svc.cluster.local --service-account-key-file=/etc/kubernetes/pki/sa.pub --service-account-signing-key-file=/etc/kubernetes/pki/sa.key --service-cluster-ip-range=10.96.0.0/12 --tls-cert-file=/etc/kubernetes/pki/apiserver.crt --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
    root        5754    5601  0 05:15 pts/0    00:00:00 grep etcd

    cluster2-controlplane ~ ➜  
    You can see the same information by inspecting the kube-apiserver pod (which runs as a static pod in the kube-system namespace):

    cluster2-controlplane ~ ➜  kubectl -n kube-system describe pod kube-apiserver-cluster2-controlplane 
    Name:                 kube-apiserver-cluster2-controlplane
    Namespace:            kube-system
    Priority:             2000001000
    Priority Class Name:  system-node-critical
    Node:                 cluster2-controlplane/10.1.127.3
    Start Time:           Wed, 31 Aug 2022 05:03:45 +0000
    Labels:               component=kube-apiserver
                        tier=control-plane
    Annotations:          kubeadm.kubernetes.io/kube-apiserver.advertise-address.endpoint: 10.1.127.3:6443
                        kubernetes.io/config.hash: 9bd4c04b38b27661e9e7f8b0fc1237b8
                        kubernetes.io/config.mirror: 9bd4c04b38b27661e9e7f8b0fc1237b8
                        kubernetes.io/config.seen: 2022-08-31T05:03:28.843162256Z
                        kubernetes.io/config.source: file
                        seccomp.security.alpha.kubernetes.io/pod: runtime/default
    Status:               Running
    IP:                   10.1.127.3
    IPs:
    IP:           10.1.127.3
    Controlled By:  Node/cluster2-controlplane
    Containers:
    kube-apiserver:
        Container ID:  containerd://cc64f3649222f24d3fd2eb7d5f0f17db5fca76eb72dc4c17295fb4842c045f1b
        Image:         k8s.gcr.io/kube-apiserver:v1.24.0
        Image ID:      k8s.gcr.io/kube-apiserver@sha256:a04522b882e919de6141b47d72393fb01226c78e7388400f966198222558c955
        Port:          <none>
        Host Port:     <none>
        Command:
        kube-apiserver
        --advertise-address=10.1.127.3
        --allow-privileged=true
        --authorization-mode=Node,RBAC
        --client-ca-file=/etc/kubernetes/pki/ca.crt
        --enable-admission-plugins=NodeRestriction
        --enable-bootstrap-token-auth=true
        --etcd-cafile=/etc/kubernetes/pki/etcd/ca.pem
        --etcd-certfile=/etc/kubernetes/pki/etcd/etcd.pem
        --etcd-keyfile=/etc/kubernetes/pki/etcd/etcd-key.pem
        --etcd-servers=https://10.1.127.10:2379
    --------- End of Snippet---------
    ```


    

9. What is the IP address of the External ETCD datastore used in cluster2?

    Alternatively, inspect the kube-apiserver pod and look at the value used for etcd-servers

10. What is the default data directory used the for ETCD datastore used in cluster1?
Remember, this cluster uses a Stacked ETCD topology. Make sure to switch the context to cluster1: `kubectl config use-context cluster1`

    Inspect the value assigned to data-dir on the etcd pod:
    ```
    student-node ~ ➜  kubectl config use-context cluster1
    Switched to context "cluster1".

    student-node ~ ➜  kubectl -n kube-system describe pod etcd-cluster1-controlplane | grep data-dir
        --data-dir=/var/lib/etcd

    student-node ~ ➜  
    ```

12. What is the default data directory used the for ETCD datastore used in cluster2? Remember, this cluster uses an External ETCD topology.

    ```
    student-node ~ ➜  ssh 192.24.186.3
    Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 5.4.0-1106-gcp x86_64)

    * Documentation:  https://help.ubuntu.com
    * Management:     https://landscape.canonical.com
    * Support:        https://ubuntu.com/advantage
    This system has been minimized by removing packages and content that are
    not required on a system that users do not log into.

    To restore this content, you can run the 'unminimize' command.

    etcd-server ~ ➜  ps -ef | grep etcd
    etcd         815       1  0 17:43 ?        00:01:46 /usr/local/bin/etcd --name etcd-server --data-dir=/var/lib/etcd-data --cert-file=/etc/etcd/pki/etcd.pem --key-file=/etc/etcd/pki/etcd-key.pem --peer-cert-file=/etc/etcd/pki/etcd.pem --peer-key-file=/etc/etcd/pki/etcd-key.pem --trusted-ca-file=/etc/etcd/pki/ca.pem --peer-trusted-ca-file=/etc/etcd/pki/ca.pem --peer-client-cert-auth --client-cert-auth --initial-advertise-peer-urls https://192.24.186.3:2380 --listen-peer-urls https://192.24.186.3:2380 --advertise-client-urls https://192.24.186.3:2379 --listen-client-urls https://192.24.186.3:2379,https://127.0.0.1:2379 --initial-cluster-token etcd-cluster-1 --initial-cluster etcd-server=https://192.24.186.3:2380 --initial-cluster-state new
    root        1043     966  0 19:24 pts/0    00:00:00 grep etcd  
    ```

13. How many nodes are part of the ETCD cluster that etcd-server is a part of?

    Check the members of the cluster:
    ```
    etcd-server ~ ➜  ETCDCTL_API=3 etcdctl \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/etcd/pki/ca.pem \
    --cert=/etc/etcd/pki/etcd.pem \
    --key=/etc/etcd/pki/etcd-key.pem \
    member list
    f0f805fc97008de5, started, etcd-server, https://10.1.218.3:2380, https://10.1.218.3:2379, false

    etcd-server ~ ➜  
    ```
    This shows that there is only one member in this cluster.

14. Take a backup of etcd on cluster1 and save it on the student-node at the path /opt/cluster1.db

    If needed, make sure to set the context to cluster1 (on the student-node):
    ```
    student-node ~ ➜  kubectl config use-context cluster1
    Switched to context "cluster1".

    student-node ~ ➜ 
    ```

    On the student-node:

    First set the context to cluster1:
    ```
    student-node ~ ➜  kubectl config use-context cluster1
    Switched to context "cluster1".
    ```


    Next, inspect the endpoints and certificates used by the etcd pod. We will make use of these to take the backup.

    ```
    student-node ~ ✖ kubectl describe  pods -n kube-system etcd-cluster1-controlplane  | grep advertise-client-urls
        --advertise-client-urls=https://10.1.218.16:2379

    student-node ~ ➜  

    student-node ~ ➜  kubectl describe  pods -n kube-system etcd-cluster1-controlplane  | grep pki
        --cert-file=/etc/kubernetes/pki/etcd/server.crt
        --key-file=/etc/kubernetes/pki/etcd/server.key
        --peer-cert-file=/etc/kubernetes/pki/etcd/peer.crt
        --peer-key-file=/etc/kubernetes/pki/etcd/peer.key
        --peer-trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
        --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
        /etc/kubernetes/pki/etcd from etcd-certs (rw)
        Path:          /etc/kubernetes/pki/etcd

    student-node ~ ➜  

    ```

    SSH to the controlplane node of cluster1 and then take the backup using the endpoints and certificates we identified above:
    ```

    cluster1-controlplane ~ ➜  ETCDCTL_API=3 etcdctl --endpoints=https://192.24.186.12:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/cluster1.db
    Snapshot saved at /opt/cluster1.db

    cluster1-controlplane ~ ➜  
    ```


    Finally, copy the backup to the student-node. To do this, go back to the student-node and use scp as shown below:
    ```

    student-node ~ ➜  scp cluster1-controlplane:/opt/cluster1.db /opt
    cluster1.db                                                                                                        100% 2088KB 112.3MB/s   00:00    

    student-node ~ ➜ 

    ```

15. An ETCD backup for cluster2 is stored at /opt/cluster2.db. Use this snapshot file to carryout a restore on cluster2 to a new path /var/lib/etcd-data-new. Once the restore is complete, ensure that the controlplane components on cluster2 are running.

    The snapshot was taken when there were objects created in the critical namespace on cluster2. These objects should be available post restore.

    If needed, make sure to set the context to cluster2 (on the student-node):

    Step 1. Copy the snapshot file from the student-node to the etcd-server. In the example below, we are copying it to the /root directory:
    ```
    student-node ~  scp /opt/cluster2.db etcd-server:/root
    cluster2.db                                                                                                        100% 1108KB 178.5MB/s   00:00    

    student-node ~ ➜  
    ```


    Step 2: Restore the snapshot on the cluster2. Since we are restoring directly on the etcd-server, we can use the endpoint https:/127.0.0.1. Use the same certificates that were identified earlier. Make sure to use the data-dir as /var/lib/etcd-data-new:
    ```

    etcd-server ~ ➜  ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/etcd/pki/ca.pem --cert=/etc/etcd/pki/etcd.pem --key=/etc/etcd/pki/etcd-key.pem snapshot restore /root/cluster2.db --data-dir /var/lib/etcd-data-new
    {"level":"info","ts":1662004927.2399247,"caller":"snapshot/v3_snapshot.go:296","msg":"restoring snapshot","path":"/root/cluster2.db","wal-dir":"/var/lib/etcd-data-new/member/wal","data-dir":"/var/lib/etcd-data-new","snap-dir":"/var/lib/etcd-data-new/member/snap"}
    {"level":"info","ts":1662004927.2584803,"caller":"membership/cluster.go:392","msg":"added member","cluster-id":"cdf818194e3a8c32","local-member-id":"0","added-peer-id":"8e9e05c52164694d","added-peer-peer-urls":["http://localhost:2380"]}
    {"level":"info","ts":1662004927.264258,"caller":"snapshot/v3_snapshot.go:309","msg":"restored snapshot","path":"/root/cluster2.db","wal-dir":"/var/lib/etcd-data-new/member/wal","data-dir":"/var/lib/etcd-data-new","snap-dir":"/var/lib/etcd-data-new/member/snap"}

    etcd-server ~ ➜  
    ```


    Step 3: Update the systemd service unit file for etcdby running vi /etc/systemd/system/etcd.service and add the new value for data-dir:
    ```

    [Unit]
    Description=etcd key-value store
    Documentation=https://github.com/etcd-io/etcd
    After=network.target

    [Service]
    User=etcd
    Type=notify
    ExecStart=/usr/local/bin/etcd \
    --name etcd-server \
    --data-dir=/var/lib/etcd-data-new \
    ---End of Snippet---
    ```

    Step 4: make sure the permissions on the new directory is correct (should be owned by etcd user):
    ```

    etcd-server /var/lib ➜  chown -R etcd:etcd /var/lib/etcd-data-new

    etcd-server /var/lib ➜ 


    etcd-server /var/lib ➜  ls -ld /var/lib/etcd-data-new/
    drwx------ 3 etcd etcd 4096 Sep  1 02:41 /var/lib/etcd-data-new/
    etcd-server /var/lib ➜ 
    ```


    Step 5: Finally, reload and restart the etcd service.

    ```
    etcd-server ~/default.etcd ➜  systemctl daemon-reload 
    etcd-server ~ ➜  systemctl restart etcd
    etcd-server ~ ➜  
    ```


    Step 6 (optional): It is recommended to restart controlplane components (e.g. kube-scheduler, kube-controller-manager, kubelet) to ensure that they don't rely on some stale data.

