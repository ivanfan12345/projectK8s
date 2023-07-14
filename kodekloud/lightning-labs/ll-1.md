1. Upgrade the current version of kubernetes from 1.26.0 to 1.27.0 exactly using the kubeadm utility. Make sure that the upgrade is carried out one node at a time starting with the controlplane node. To minimize downtime, the deployment gold-nginx should be rescheduled on an alternate node before upgrading each node.

    Upgrade controlplane node first and drain node node01 before upgrading it. Pods for gold-nginx should run on the controlplane node subsequently.

        - Cluster Upgraded?
        - pods 'gold-nginx' running on controlplane?

    <details>

    1. Drain node

        ```
        kubectl drain controlplane --ignore-daemonsets
        ```

    1. Upgrade kubeadm

        ```
        apt-get update
        apt-mark unhold kubeadm
        apt-get install -y kubeadm=1.27.0-00
        ```

    1. Plan and apply upgrade

        ```
        kubeadm upgrade plan
        kubeadm upgrade apply v1.27.0
        ```

    1. Remove taint on controlplane node. This is the issue described above. As part of the upgrade specifically to 1.26, some taints are added to all controlplane nodes. This will prevent the `gold-nginx` pod from being rescheduled to the controlplane node later on.

        ```
        kubectl describe node controlplane | grep -A 3 taint
        ```

        Output:

        ```
        Taints:   node-role.kubernetes.io/control-plane:NoSchedule
                  node.kubernetes.io/unschedulable:NoSchedule
        ```

        Let's remove them

        ```
        kubectl taint node controlplane node-role.kubernetes.io/control-plane:NoSchedule-
        kubectl taint node controlplane node.kubernetes.io/unschedulable:NoSchedule-
        ```

    1. Upgrade the kubelet

        ```
        apt-mark unhold kubelet
        apt-get install -y kubelet=1.27.0-00
        systemctl daemon-reload
        systemctl restart kubelet
        ```

    1. Reinstate controlplane node

        ```
        kubectl uncordon controlplane
        ```

    1. Upgrade kubectl

        ```
        apt-mark unhold kubectl
        apt-get install -y kubectl=1.27.0-00
        ```

    1. Re-hold packages

        ```
        apt-mark hold kubeadm kubelet kubectl
        ```

    1. Drain the worker node

        ```
        kubectl drain node01 --ignore-daemonsets
        ```

    1. Go to worker node

        ```
        ssh node01
        ```

    1. Upgrade kubeadm

        ```
        apt-get update
        apt-mark unhold kubeadm
        apt-get install -y kubeadm=1.27.0-00
        ```

    1. Upgrade node

        ```
        kubeadm upgrade node
        ```

    1. Upgrade the kubelet

        ```
        apt-mark unhold kubelet
        apt-get install kubelet=1.27.0-00
        systemctl daemon-reload
        systemctl restart kubelet
        ```

    1. Re-hold packages

        ```
        apt-mark hold kubeadm kubelet
        ```

    1. Return to controlplane

        ```
        exit
        ```

    1. Reinstate worker node

        ```
        kubectl uncordon node01
        ```

    1. Verify `gold-nginx` is scheduled on controlplane node

        ```
        kubectl get pods -o wide | grep gold-nginx
        ```
    </details>



2. Print the names of all deployments in the admin2406 namespace in the following format:

    `DEPLOYMENT CONTAINER_IMAGE READY_REPLICAS NAMESPACE`

    `<deployment name> <container image used> <ready replica count> <Namespace>`. The data should be sorted by the increasing order of the deployment name.


    Example:

    `DEPLOYMENT CONTAINER_IMAGE READY_REPLICAS NAMESPACE`
    `deploy0 nginx:alpine 1 admin2406`
    Write the result to the file `/opt/admin2406_data`.

    

3. A kubeconfig file called admin.kubeconfig has been created in /root/CKA. There is something wrong with the configuration. Troubleshoot and fix it.

    ```
    k get po --kubeconfig=/root/CKA/admin.kubeconfig

    E0703 13:20:45.789465   28682 memcache.go:265] couldn't get current server API group list: Get "https://controlplane:4380/api?timeout=32s": dial tcp 192.29.231.9:4380: connect: connection refused
    E0703 13:20:45.791017   28682 memcache.go:265] couldn't get current server API group list: Get "https://controlplane:4380/api?timeout=32s": dial tcp 192.29.231.9:4380: connect: connection refused
    E0703 13:20:45.791328   28682 memcache.go:265] couldn't get current server API group list: Get "https://controlplane:4380/api?timeout=32s": dial tcp 192.29.231.9:4380: connect: connection refused
    E0703 13:20:45.792848   28682 memcache.go:265] couldn't get current server API group list: Get "https://controlplane:4380/api?timeout=32s": dial tcp 192.29.231.9:4380: connect: connection refused
    E0703 13:20:45.794382   28682 memcache.go:265] couldn't get current server API group list: Get "https://controlplane:4380/api?timeout=32s": dial tcp 192.29.231.9:4380: connect: connection refused
    The connection to the server controlplane:4380 was refused - did you specify the right host or port?
    ```
    Wrong port used for `"https://controlplane:4380` update config for: `server: https://controlplane:6443`
    ```
    k get po --kubeconfig=/root/CKA/admin.kubeconfig
    NAME                          READY   STATUS    RESTARTS   AGE
    gold-nginx-6c5b9dd56c-hpvs8   1/1     Running   0          23m
    ```




4. Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Next upgrade the deployment to version 1.17 using rolling update.

    - Image: nginx:1.16
    - Task: Upgrade the version of the deployment to 1:17

    `kubectl create deployment nginx-deploy --image=nginx:1.16`
    `kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record`

5. A new deployment called alpha-mysql has been deployed in the alpha namespace. However, the pods are not running. Troubleshoot and fix the issue. The deployment should make use of the persistent volume alpha-pv to be mounted at /var/lib/mysql and should use the environment variable MYSQL_ALLOW_EMPTY_PASSWORD=1 to make use of an empty root password.

    Important: Do not alter the persistent volume.
    Troubleshoot and fix the issues
    ```
    k get pv
    NAME       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                   STORAGECLASS   REASON   AGE
    alpha-pv   1Gi        RWO            Retain           Bound    alpha/mysql-alpha-pvc   slow                    51m
    ```
    Check pod description:
    missing PVC
    `pvc.yaml`
    ```
    cat pvc.yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
    name: mysql-alpha-pvc
    namespace: alpha
    spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
        storage: 1Gi
    storageClassName: slow
    ```

6. Take the backup of ETCD at the location /opt/etcd-backup.db on the controlplane node. Troubleshoot and fix the issues

    `ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/etcd-backup.db`

7. Create a pod called secret-1401 in the admin1401 namespace using the busybox image. The container within the pod should be called secret-admin and should sleep for 4800 seconds. The container should mount a read-only secret volume called secret-volume at the path /etc/secret-volume. The secret being mounted has already been created for you and is called dotfile-secret.

    `secret-1401.yaml`
    ```
    apiVersion: v1
    kind: Pod
    metadata:
    creationTimestamp: null
    labels:
        run: secret-1401
    name: secret-1401
    namespace: admin1401
    spec:
    containers:
    - image: busybox
        name: secret-admin
        resources: {}
        command: ["sleep","4800"]
        volumeMounts:
        - name: secret-volume
        readOnly: true
        mountPath: "/etc/secret-volume"
    dnsPolicy: ClusterFirst
    restartPolicy: Always
    volumes:
    - name: secret-volume
        secret:
        secretName: dotfile-secret
    status: {}
    ```

    

7.

    

8.

    

9.

    

10.

