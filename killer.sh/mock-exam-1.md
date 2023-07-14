1. You have access to multiple clusters from your main terminal through kubectl contexts. Write all those context names into `/opt/course/1/contexts`.

    Next write a command to display the current context into `/opt/course/1/context_default_kubectl.sh`, the command should use kubectl.

    Finally write a second command doing the same thing into `/opt/course/1/context_default_no_kubectl.sh`, but without the use of kubectl.

2. Create a single Pod of image` httpd:2.4.41-alpine` in Namespace `default`. The Pod should be named pod1 and the container should be named `pod1-container`. This Pod should only be scheduled on a `controlplane` node, do not add new labels any nodes.

3. There are two Pods named `o3db-*` in Namespace `project-c13`. C13 management asked you to scale the Pods down to one replica to save resources.

4. Do the following in Namespace `default`. Create a single Pod named `ready-if-service-ready` of image `nginx:1.16.1-alpine`. Configure a `LivenessProbe` which simply executes command `true`. Also configure a `ReadinessProbe` which does check if the url `http://service-am-i-ready:80` is reachable, you can use `wget -T2 -O- http://service-am-i-ready:80` for this. Start the Pod and confirm it isn't ready because of the `ReadinessProbe`.

    Create a second Pod named `am-i-ready` of image `nginx:1.16.1-alpine` with label `id: cross-server-ready`. The already existing Service service-am-i-ready should now have that second Pod as endpoint.

    Now the first Pod should be in ready state, confirm that.

5. There are various Pods in all namespaces. Write a command into `/opt/course/5/find_pods.sh` which lists all Pods sorted by their `AGE (metadata.creationTimestamp)`.

    Write a second command into `/opt/course/5/find_pods_uid.sh` which lists all Pods sorted by field `metadata.uid`. Use `kubectl` sorting for both commands.k 

6. Create a new PersistentVolume named `safari-pv`. It should have a capacity of 2Gi, accessMode ReadWriteOnce, hostPath `/Volumes/Data` and no storageClassName defined.

    Next create a new `PersistentVolumeClaim` in Namespace `project-tiger` named `safari-pvc` . It should request `2Gi` storage, accessMode `ReadWriteOnce` and should not define a storageClassName. The PVC should bound to the PV correctly.

    Finally create a new Deployment `safari` in Namespace `project-tiger` which mounts that volume at `/tmp/safari-data`. The Pods of that Deployment should be of image `httpd:2.4.41-alpine`.

7. The metrics-server has been installed in the cluster. Your college would like to know the kubectl commands to:

    1. show Nodes resource usage
    2. show Pods and their containers resource usage
    
    Please write the commands into `/opt/course/7/node.sh` and `/opt/course/7/pod.sh`.

8. Ssh into the controlplane node with ssh cluster1-controlplane1. Check how the controlplane components kubelet, kube-apiserver, kube-scheduler, kube-controller-manager and etcd are started/installed on the controlplane node. Also find out the name of the DNS application and how it's started/installed on the controlplane node.

Write your findings into file `/opt/course/8/controlplane-components.txt`. The file should be structured like:
    ```
    # /opt/course/8/controlplane-components.txt
    kubelet: [TYPE]
    kube-apiserver: [TYPE]
    kube-scheduler: [TYPE]
    kube-controller-manager: [TYPE]
    etcd: [TYPE]
    dns: [TYPE] [NAME]
    Choices of [TYPE] are: not-installed, process, static-pod, pod
    ```

9. Ssh into the controlplane node with `ssh cluster2-controlplane1`. Temporarily stop the kube-scheduler, this means in a way that you can start it again afterwards.

    Create a single Pod named `manual-schedule` of image `httpd:2.4-alpine`, confirm it's created but not scheduled on any node.

    Now you're the scheduler and have all its power, manually schedule that Pod on node `cluster2-controlplane1`. Make sure it's running.

    Start the kube-scheduler again and confirm it's running correctly by creating a second Pod named `manual-schedule2` of image` httpd:2.4-alpine` and check if it's running on `cluster2-node1`.

 