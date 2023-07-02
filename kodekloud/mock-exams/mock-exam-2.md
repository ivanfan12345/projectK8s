1. Take a backup of the etcd cluster and save it to `/opt/etcd-backup.db`.

    `ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=<trusted-ca-file> --cert=<cert-file> --key=<key-file> \
  snapshot save <backup-file-location>`

    File locations can be found in etcd parameters: `/etc/kubernetes/manifests/etcd.yaml`

    `ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /opt/etcd-backup.db`


2. Create a Pod called redis-storage with image: redis:alpine with a Volume of type emptyDir that lasts for the life of the Pod.

    Specs on the below.
    Pod named 'redis-storage' created
    Pod 'redis-storage' uses Volume type of emptyDir
    Pod 'redis-storage' uses volumeMount with mountPath = /data/redis

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: redis-storage
      name: redis-storage
    spec:
    volumes:
    - name: redis-storage
      emptyDir: {}
    
    containers:
    - image: redis:alpine
      name: redis-storage
      resources: {}
      volumeMounts:
      - name: redis-storage
        mountPath: /data/redis
    dnsPolicy: ClusterFirst
    restartPolicy: Always
    ```

3. Create a new pod called super-user-pod with image busybox:1.28. Allow the pod to be able to set system_time.

    The container should sleep for 4800 seconds.
    Pod: super-user-pod
    Container Image: busybox:1.28
    Is SYS_TIME capability set for the container?

    ```
    apiVersion: v1
    kind: Pod
    metadata:
      name: super-user-pod
    spec:
      containers:
      - name: super-user
        image: busybox:1.28
        command: ['sh', '-c', 'sleep 4800']
        securityContext:
          capabilities:
            add: ["SYS_TIME"]
    ```

  4. A pod definition file is created at /root/CKA/use-pv.yaml. Make use of this manifest file and mount the persistent volume called pv-1. Ensure the pod is running and the PV is bound.

  mountPath: /data

  persistentVolumeClaim Name: my-pvc

  - persistentVolume Claim configured correctly
  - pod using the correct mountPath
  - pod using the persistent volume claim?
    
    `pvc`:
    ```
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: my-pvc
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 10Mi
    ```
    pod:
    ```
    apiVersion: v1
    kind: Pod
    metadata:
      creationTimestamp: null
      labels:
        run: use-pv
      name: use-pv
    spec:
      containers:
      - image: nginx
        name: use-pv
        volumeMounts:
        - mountPath: "/data"
          name: mypod
      volumes:
      - name: mypod
        persistentVolumeClaim:
          claimName: my-pvc
    ```
5. Create a new deployment called nginx-deploy, with image nginx:1.16 and 1 replica. Next upgrade the deployment to version 1.17 using rolling update.

    Deployment : nginx-deploy. Image: nginx:1.16
    Image: nginx:1.16
    Task: Upgrade the version of the deployment to 1:17
    Task: Record the changes for the image upgrade
    ```
    kubectl create deployment nginx-deploy --image=nginx:1.16 --dry-run=client -o yaml > deploy.yaml
    ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: nginx-deploy
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: nginx-deploy
      strategy: {}
      template:
        metadata:
          creationTimestamp: null
          labels:
            app: nginx-deploy
        spec:
          containers:
          - image: nginx:1.16
            name: nginx
    ```
    Rolling Upgrade:
    ```
    kubectl create -f deploy.yaml --record
    kubectl rollout history deployment nginx-deploy
    kubectl set image deployment/nginx-deploy nginx=nginx:1.17 --record
    kubectl rollout history deployment nginx-deploy
    ```

6. Create a new user called john. Grant him access to the cluster. John should have permission to create, list, get, update and delete pods in the development namespace . The private key exists in the location: /root/CKA/john.key and csr at /root/CKA/john.csr.

  Important Note: As of kubernetes 1.19, the CertificateSigningRequest object expects a signerName.

  Please refer the documentation to see an example. The documentation tab is available at the top right of terminal.

  CSR: john-developer Status:Approved
  Role Name: developer, namespace: development, Resource: Pods
  Access: User 'john' has appropriate permissions

7. Create a nginx pod called nginx-resolver using image nginx, expose it internally with a service called nginx-resolver-service. Test that you are able to look up the service and pod names from within the cluster. Use the image: busybox:1.28 for dns lookup. Record results in /root/CKA/nginx.svc and /root/CKA/nginx.pod


  Pod: nginx-resolver created
  Service DNS Resolution recorded correctly
  Pod DNS resolution recorded correctly

8. Create a static pod on node01 called nginx-critical with image nginx and make sure that it is recreated/restarted automatically in case of a failure.

  Use /etc/kubernetes/manifests as the Static Pod path for example.
  static pod configured under /etc/kubernetes/manifests ?
  Pod nginx-critical-node01 is up and running