1. We have a working Kubernetes cluster with a set of web applications running. Let us first explore the setup. How many deployments exist in the cluster?

    `k get deploy`

2. What is the version of ETCD running on the cluster? Check the ETCD Pod or Process

    Look at the ETCD Logs OR check the image used by ETCD pod.

    Look at the ETCD Logs using the command kubectl logs etcd-controlplane -n kube-system or check the image used by the ETCD pod: kubectl describe pod etcd-controlplane -n kube-system
    ```
    root@controlplane:~# kubectl -n kube-system logs etcd-controlplane | grep -i 'etcd-version'
    "caller":"embed/etcd.go:306","msg":"starting an etcd server","etcd-version":"3.5.7","git-sha":"215b53cf3"

    root@controlplane:~# 

    root@controlplane:~# kubectl -n kube-system describe pod etcd-controlplane | grep Image:
        Image:         registry.k8s.io/etcd:3.5.7-0
    root@controlplane:~#
    ```

3. At what address can you reach the ETCD cluster from the controlplane node? Check the ETCD Service configuration in the ETCD POD

    Use the command `kubectl describe pod etcd-controlplane -n kube-system` and look for `--listen-client-urls`.
    ```
    root@controlplane:~# kubectl -n kube-system describe pod etcd-controlplane | grep '\--listen-client-urls'
        --listen-client-urls=https://127.0.0.1:2379,https://10.2.43.11:2379
    root@controlplane:~#
    ```
    This means that ETCD is reachable on localhost (127.0.0.1) at port 2379.

4. Where is the ETCD server certificate file located? Note this path down as you will need to use it later

    Check the ETCD pod configuration with the command: kubectl describe pod etcd-controlplane -n kube-system and look for the value for --cert-file:
    ```
    root@controlplane:~# kubectl -n kube-system describe pod etcd-controlplane | grep '\--cert-file'
        --cert-file=/etc/kubernetes/pki/etcd/server.crt
    root@controlplane:~#
    ```

5. Where is the ETCD CA Certificate file located? Note this path down as you will need to use it later.

    Check the ETCD pod configuration with the command: `kubectl describe pod etcd-controlplane -n kube-system` and look for the value of `--trusted-ca-file`:
    ```
    root@controlplane:~# kubectl -n kube-system describe pod etcd-controlplane | grep '\--trusted-ca-file'
        --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
    root@controlplane:~#
    ```

6. The master node in our cluster is planned for a regular maintenance reboot tonight. While we do not anticipate anything to go wrong, we are required to take the necessary backups. Take a snapshot of the ETCD database using the built-in snapshot functionality. Store the backup file at location /opt/snapshot-pre-boot.db

    Use the etcdctl snapshot save command. You will have to make use of additional flags to connect to the ETCD server.

    --endpoints: Optional Flag, points to the address where ETCD is running (127.0.0.1:2379)
    --cacert: Mandatory Flag (Absolute Path to the CA certificate file)
    --cert: Mandatory Flag (Absolute Path to the Server certificate file)
    --key: Mandatory Flag (Absolute Path to the Key file)

    Run the command:
    ```
    root@controlplane:~# ETCDCTL_API=3 etcdctl --endpoints=https://[127.0.0.1]:2379 \
    --cacert=/etc/kubernetes/pki/etcd/ca.crt \
    --cert=/etc/kubernetes/pki/etcd/server.crt \
    --key=/etc/kubernetes/pki/etcd/server.key \
    snapshot save /opt/snapshot-pre-boot.db

    Snapshot saved at /opt/snapshot-pre-boot.db
    root@controlplane:~# 
    ```
    You may also refer the solution here
    


8. Wake up! We have a conference call! After the reboot the master nodes came back online, but none of our applications are accessible. Check the status of the applications on the cluster. What's wrong?

    Are you able to see any deployments/pods or services in the default namespace?

8. Luckily we took a backup. Restore the original state of the cluster using the backup file.

    Deployments: 2
    Services: 3

    Restore the etcd to a new directory from the snapshot by using the etcdctl snapshot restore command. Once the directory is restored, update the ETCD configuration to use the restored directory.

    First Restore the snapshot:
    ```
    root@controlplane:~# ETCDCTL_API=3 etcdctl  --data-dir /var/lib/etcd-from-backup \
    snapshot restore /opt/snapshot-pre-boot.db


    2022-03-25 09:19:27.175043 I | mvcc: restore compact to 2552
    2022-03-25 09:19:27.266709 I | etcdserver/membership: added member 8e9e05c52164694d [http://localhost:2380] to cluster cdf818194e3a8c32
    root@controlplane:~# 
    ```

    Note: In this case, we are restoring the snapshot to a different directory but in the same server where we took the backup (the controlplane node) As a result, the only required option for the restore command is the `--data-dir`.



    Next, update the `/etc/kubernetes/manifests/etcd.yaml`:

    We have now restored the etcd snapshot to a new path on the controlplane -` /var/lib/etcd-from-backup`, so, the only change to be made in the YAML file, is to change the hostPath for the volume called etcd-data from old directory (`/var/lib/etcd`) to the new directory (`/var/lib/etcd-from-backup`).
    ```
    volumes:
    - hostPath:
        path: /var/lib/etcd-from-backup
        type: DirectoryOrCreate
        name: etcd-data
    ```
    With this change, `/var/lib/etcd` on the container points to `/var/lib/etcd-from-backup` on the `controlplane` (which is what we want).

    When this file is updated, the `ETCD` pod is automatically re-created as this is a static pod placed under the `/etc/kubernetes/manifests` directory.



    Note 1: As the ETCD pod has changed it will automatically restart, and also kube-controller-manager and kube-scheduler. Wait 1-2 to mins for this pods to restart. You can run the command: watch "crictl ps | grep etcd" to see when the ETCD pod is restarted.

    Note 2: If the etcd pod is not getting Ready 1/1, then restart it by kubectl delete pod -n kube-system etcd-controlplane and wait 1 minute.

    Note 3: This is the simplest way to make sure that ETCD uses the restored data after the ETCD pod is recreated. You don't have to change anything else.



    If you do change --data-dir to /var/lib/etcd-from-backup in the ETCD YAML file, make sure that the volumeMounts for etcd-data is updated as well, with the mountPath pointing to /var/lib/etcd-from-backup (THIS COMPLETE STEP IS OPTIONAL AND NEED NOT BE DONE FOR COMPLETING THE RESTORE

9.

    

10.

