# https://www.youtube.com/watch?v=Qbx2dy4wz4Q

1. Contexts

    You have access to multiple clusters from your main terminal through `kubectl` contexts. Write all those context names into `/opt/course/1/contexts`.

    Next write a command to display current context into `/opt/course/1/context_default_kubectl.sh` the command should use kubectl.

    Finally write a second command doing the same thing into `/opt/course/1/context_default_no_kubectl.sh , but without the use of kubectl.


2. Schedule Pod on Controlplane Node

    Create a single pod of image `httpd:2.4.41-alpine` in the Namespace `default`. The Pod should be named pod1 and the container should be named pod1-container. This pod should only be scheduled on a controlplane node, do not add new labels any nodes. 

3. Scale down StatefulSet

    There are two pods named `o3db-*` in Namespace `porject-c13`. C13 management asked you to scale the Pods down to one replica to save resources.

4. Pod Ready if Service is reachable

    Do the following in Namespace `default`. Create a single Pod named `ready-if-service-ready` of image `nginx:1.16.1-alpine`. Configure a LivenessProbe which simply executes command `true`. Also configure a ReadinessProbe which does check if the url `http://service-ami-ready:80` is reachable, you can use `wget -T2 -O- http://service-am-i-ready:80 for this. Start the Pod and confirm it isn't ready because of the ReadinessProble.

    Create a second pod named `am-i-ready` of image `nginx:1.16.1-alpine` with label `id: cross-server-read`. The already existing Service `service-am-i-read` should now have that second Pod as endpoint.

    Now the first Pod should be in a ready state, confirm that.

5. kubectl sorting

    There are various Pods in all namespaces. Write a command into `/opt/course5/find_pods.sh` which lists all Pods sorted by their AGE (metadata.creationTimestamp).

    Write a seocnd command into /opt/course/5/find_pods_uid.sh` which lists all Pods sorted by field `metadata.uid`. Use `kubectl` sorting for both commands.

6. Storage, PV , PVC , Pod Volume/Mounting

    Create a new `PersistentVolume` named `safari-pv`. It should have a capacity of 2Gi, accessMode ReadWriteOnce, HostPath `/Volumes/Data` and no storageClassName defined.

    Next create a new PersistentVolumeClain in Namespace `project-tiger` named `safari-pvc`. It should request 2Gi storage, accessMode ReadWriteOnce and should not define a storageClassName. The PVC should bound to the PV correctly.

    Finally careate a new Deployment `safari` in NAmespace `porject-tiger` which mounts that volume at `/tmp/safari-data`. The Pods of that deployment should be of image httpd:2.4.41-alpine.

7. Node and Pod Resource Usage:

    The metrics-server has been installed in the cluster. Your colelge would like to know the kubectl commands to: 

    1. show Nodes resource usage.
    2. show Pods and their containers resource usage

    Please write the commands into `/opt/course/7/node.sh` and `/opt/course/7/pod.sh`.

8. Get Controplane Information:

    `SSH` into the controlplane node with `ssh cluster1-controplane1`. Check how the controlplane components kubelet, kube-apiserver, kube-shceduler, kube-controller-manager, and etcd are started/installed on the controplane node. Also find out the name of the DNS application and how it's started/installed on the controlplane node.

    write your findings info file `/opt/course/8/controplane-components.txt`. The file should be strucuted like:
    ```
    # /opt/course/8/controplane-components.txt
    kubelet: [TYPE]
    kube-apiserver: [TYPE]
    kube-scheduler: [TYPE]
    kube-controller-manager: [TYPE]
    etcd: [TYPE]
    dns: [TYPE] [NAME]

    ``` 

9. Kill Scheduler, Manual Scheduling

    `SSH` into the controplane node with `ssh cluster2-controlplane1`. Temporarily stop the `kube-scheduler`, this means in a way that you can start it again afterwards.

    Create a single Pod named `manual-scheudle` of image `httpd:2.4-alpine`, confirm it's created but not shceduled on any node. 

    Now you're the scheduler and have all it's power, manually schedule that pod on node cluster-controlplane1. Make sure it's running.

    Start the kube-scheduler again and confirm it's running correctly by creating a second Pod named `manual-shcedule2` of image `httpd:2.4-alpine`.

10. RBAC ServiceAccount Role RoleBinding

    Create a new ServiceAccount `processor` in namespace `project-hamster`. Create a Role and RoleBinding, both named `processor` as well. These should allow the new SA to only create secrets and ConfigMaps in that Namespace.

11.  DaemonSet on all Nodes

    Use namespace `project-tiger` for the following. Create a DaemonSet named `ds-important` with image `httpd:2.4-alpine` and labels `id-dsimportant` and `uuid-18426a0b-5f59-4e10-923f-c0e078e82462`. The Pods it creates should request 10 millicore cpu and 10 mebibyte memory. The Pods of the DaemonSet should run on all nodes, also controlplane. 

12. Deployment on all Nodes

    Use namespace `project-tiger` for the following. Create a Deployment named `deploy-important` with label `id=very-important` (the pods should also have this label) and 3 replicas. It should contain two containers, the first named `container1` with image `nginx:1.17.6-alpine` and the second one named container2 with image `kubernetes/pause`.

    There should be only ever one pod of that deployment running on one worker node. We have two worker nodes: cluster1-node1 and cluster1-node2. Because the deployment has three replicas the result should be that on both nodes one pod is running. The third pod won't be scheduled, unless a new worker node will be added.

    In a way we kind of simulate the behavior of a daemonset here, but using deployment and a fixed number of replicas.

13. Multi Containers and Pod shared Volume.

    Create a pod named `multi-container-playground` in namespace default with three contianers, named c1, c2, c3. There should be a volume attached to the pod and mounted to every container, but the volume shouldn't be persisted or shared with other Pods.

    Container `c1` should be image of `nginx:1.17.6-alpine` and have the name of the node where its pod is running available as environment variable `MY_NODE_NAME`.

    Container `c2` should be image `busybox:1.31.1` and write the output of the date commoand every second in the shared volume info file `date.log`. You can use `white true; do date >> /your/vol/path/date.log; sleep 1; done` for this.

    Container `c3` should be of image `busybox:1.31.1` and constantly send the content of the file `date.log` from the shared volume to stdout. You can use `tail -f /your/vol/path/date.log` for this.

    Check the logs of container c3 to confirm correct setup.

14. Find out Cluster Information

    You're ask to find out following information about the cluster `k8s-c1-H`:

    1. How many controlplane noes are available?
    2. How many workders are available?
    3. What is the Service CIDR?
    4. Which networking (or CNI Plugin) is confiugred and where is it's config file?
    5. Which suffic will static pods have that run on cluster1-node01?

    Write your answers into file `/opt/course/14/cluster-info`, structured like this:

    ```
    # /opt/course/14/cluster-info
    1: [ANSWER]
    2: [ANSWER]
    3: [ANSWER]
    4: [ANSWER]
    5: [ANSWER]

15. Cluster Event Loggin

    Write a command into `/opt/course/15/cluster_events.sh` which shows the latest events in the whole cluster, ordered by time (metadata.creationTimestamp). Use `kubectl` for it.

    Now kill the kube-proxy pod running on node clust2-node1 and write the events this cuased into `/opt/course/15/pod_kill.log`.

    Finally kill the containerd container of the kube-proxy pod on ndoe cluster2-node1 and write the events into `/opt/course/15/container_kill.log`.

16. Namespaces and API Resources

    Write the names of all namespaced Kubernetes resources (like Pod, Secret, ConfigMap ...) into `/opt/course/15/resources.txt`. Find the project-* namespace with the highest number of `Roles` defined in it and write its name and mount of roles into `/opt/course/16/crowded-namespace.txt`.

17. Find Container of Pod and check info

    In namespace `project-tiger` create a pod named `tigers-reunite` of image `httpd:2.4.41-alpine` with labels pod=container and container=pod. Find out on which node the pod is scheduled. SSH into that node and find the containerd container beloging to that pod.

    Using command crictl:

    1. Write the ID of container and the info.runtimeType into `/opt/course/17/pod-container.txt`
    2. Write the logs of the container into `/opt/course/17/pod-container.log`

18. Fix Kubelet

    There seems to be an issue with kubelet not running on `cluster3-node1`. Fix it and confirm that cluster has node `cluster3-node1` available in Read state afterwards. You should be able to schedule a Pod on `cluster3-node1` afterwards.

    Write the reason of the issue into /opt/course/18/reason.txt

19. Create Secret and mount into Pod

    Do the following in a new NAmespace `secret. Create a pod named secret-pod of image busybox:1.31.1 which should keep running for some time.

    There is an existing Secret located at /opt/course/19/secret.yaml , create it in the namespace secret and mout if readonly into the pod at /tmp/secret1.

    Createw a new secret in namespace secret called secret2 which should contain `user=user1` and pass=1234. These entries should be availble inside the pod's container as environment variables APP_USER and APP_PASS.

20. Update Kubernetes Version and join cluster.

    Your coworker said node cluster3-node2 is running an older kubernetes version and is not even part of the cluster. Update kubernetes on that node to the exact version that's running on cluster3-controlplane1. Then add this node to the cluster. Use kubeadm for this.

21. Create a static pod and service

    Create a Static Pod named `my-static-pod` in namespace default on cluster3-controlplane1. It should be of image nginx:1.16-alpine and have resource requests for 10m CPU and 20Mi memory.

    Then create a NodePort Service named `static-pod-service` which exposes that static Pod on port 80 and check if it has Endpoints and if it's reachable through the `cluster3-controplane1` internal IP address. You can connect to the internal node IPs from your main terminal.

22. Check how long certificatesd are valid.

    Check how long the kube-apiserver server certificate is valid on `cluster2-controlplane1`. Do this with openssl or cfssl. Write the expiration date into /opt/22/expiration. 

    Also run the correct kubeadm command to list the expiration dates and confirm both methods show the same date.

    Write the correct kubeadm command that would renew the apiserver server certificate into /opt/course/22/kubeadm-renew-certs.sh

23. Kubelet client/server cert info

    Node cluster2-node1 has been added to the cluster using kubeadm and TLS bootstrapping.

    Find the "Issuer" and "Extended Key Useage" values of cluster2-node1:

    1. kubelet client cert, the one used for outgoing connection to the kube-apiserver.
    2. kubelet server cert, the one used for incoming connections from the kube-apiserver.

    Write the information into file `/opt/course/23/certificate-info.txt`

    Compare the "issuer" and "Extended Key Usage" fields of both certs and make sense of these.

24. Network Policy

    There was a security incident where an intruder was able to access the whole cluster from a single hacked backend pod.

    To prevent this create a NetworkPolicy called np-backend in namespace project-snake. It should allow the bakcned-* pods only to:

        - connect to db1-* pods on port 1111
        - connect to db2-* pods on port 2222
    
    USe the app label of pods in your policy. After implementation, connections from backend-* pods to vault-* pords on port 3333 should for example no longer work.

25. Etcd Snapshot Save and Restore

    Make a backup of etcd running on cluster3-controplane1 and save it on the controlplane node at `/tmp/etcd-backup.db`. 
    
    Then create a pod of your kind in the cluster.
    
    Finally restore the backup, confirm the cluster is still working and that the created pod is no longer with us. RIP

