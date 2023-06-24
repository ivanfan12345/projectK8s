1. Let us explore the environment first. How many nodes do you see in the cluster?

    `k get no`

2. How many applications do you see hosted on the cluster?

    `k get deploy`

3. Which nodes are the applications hosted on?

    `k get po -owide`

4. We need to take node01 out for maintenance. Empty the node of all applications and mark it unschedulable.

    `kubectl drain node01 --ignore-daemonsets`

5. What nodes are the apps on now?

    `k get po -owide`

6. The maintenance tasks have been completed. Configure the node node01 to be schedulable again.

    `kubectl uncordon node01`

7. How many pods are scheduled on node01 now?

    `k get po -owide`

8. Why are there no pods on node01?

    Running the `uncordon` command on a node will not automatically schedule pods on the node. When new pods are created, they will be placed on node01.

9. Why are the pods placed on the controlplane node?

    ```
    root@controlplane:~# kubectl describe node controlplane | grep -i  taint
    Taints:             <none>
    root@controlplane:~# 
    ```
    Since there are no taints on the controlplane node, all the pods were started on it when we ran the `kubectl drain node01` command.

11. We need to carry out a maintenance activity on node01 again. Try draining the node again using the same command as before: kubectl drain node01 --ignore-daemonsets

    Run: `kubectl get pods -o wide` and you will see that there is a single pod scheduled on node01 which is not part of a replicaset.

    The drain command will not work in this case. To forcefully drain the node we now have to use the `--force` flag.

12. What is the name of the POD hosted on node01 that is not part of a replicaset?

    `kubectl get pods -o wide`

13. What would happen to hr-app if node01 is drained forcefully?

    A forceful drain of the node will delete any pod that is not part of a replicaset.

16. hr-app is a critical app and we do not want it to be removed and we do not want to schedule any more pods on node01. Mark node01 as unschedulable so that no new pods are scheduled on this node. Make sure that hr-app is not affected.

    Do not drain `node01`, instead use the `kubectl cordon node01` command. This will ensure that no new pods are scheduled on this node and the existing pods will not be affected by this operation.