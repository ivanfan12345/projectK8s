1. This lab tests your skills on upgrading a kubernetes cluster. We have a production cluster with applications running on it. Let us explore the setup first. What is the current version of the cluster?

    `kubectl get nodes`

2. How many nodes are part of this cluster?

    `kubectl get nodes`

3. How many nodes can host workloads in this cluster? Inspect the applications and taints set on the nodes.

    By running the` kubectl describe node` command, we can see that neither nodes have taints.
    ```
    root@controlplane:~# kubectl describe nodes  controlplane | grep -i taint
    Taints:             <none>
    root@controlplane:~# 
    root@controlplane:~# kubectl describe nodes  node01 | grep -i taint
    Taints:             <none>
    root@controlplane:~# 
    ```
    This means that both nodes have the ability to schedule workloads on them.

4. How many applications are hosted on the cluster?

    ```
    Run the below command and count the number of deployments:

    root@controlplane:~# kubectl get deployments.apps 
    NAME   READY   UP-TO-DATE   AVAILABLE   AGE
    blue   5/5     5            5           119s
    root@controlplane:~#
    ```
    WE have 1 deployment called blue

5. What nodes are the pods hosted on?

    `k get po -owide`

6. You are tasked to upgrade the cluster. Users accessing the applications must not be impacted, and you cannot provision new VMs. What strategy would you use to upgrade the cluster?

    In order to ensure minimum downtime, upgrade the cluster one node at a time, while moving the workloads to another node. In the upcoming tasks you will get to practice how to do that.

    

7. What is the latest stable version of Kubernetes as of today?

    Look at the remote version in the output of the `kubeadm upgrade plan` command.

8. What is the latest version available for an upgrade with the current version of the kubeadm tool installed?

    `kubeadm upgrade plan`

9. We will be upgrading the controlplane node first. Drain the controlplane node of workloads and mark it `UnSchedulable`.

    There are daemonsets created in this cluster, especially in the kube-system namespace. To ignore these objects and drain the node, we can make use of the --ignore-daemonsets flag.
    `kubectl drain controlplane --ignore-daemonsets`

10. Upgrade the `controlplane` components to exact version `v1.27.0`

    Upgrade the kubeadm tool (if not already), then the controlplane components, and finally the kubelet. Practice referring to the Kubernetes documentation page.

    Note: While upgrading kubelet, if you hit dependency issues while running the `apt-get upgrade kubelet` command, use the `apt install kubelet=1.27.0-00` command instead.

    Make sure that the correct version of kubeadm is installed and then proceed to upgrade the controlplane node. Once this is done, upgrade the kubelet on the node.

    On the controlplane node, run the following commands:
    
    This will update the package lists from the software repository.

    `apt update`

    This will install the kubeadm version 1.27.0

    `apt-get install kubeadm=1.27.0-00`

    This will upgrade Kubernetes controlplane node.

    `kubeadm upgrade apply v1.27.0`

        Note that the above steps can take a few minutes to complete.

    This will update the kubelet with the version 1.27.0.

    `apt-get install kubelet=1.27.0-00 `


    You may need to reload the daemon and restart kubelet service after it has been upgraded.
    ```
    systemctl daemon-reload
    systemctl restart kubelet
    ```

11. Mark the controlplane node as "Schedulable" again

    Run the command: `kubectl uncordon controlplane`

12. Next is the worker node. Drain the worker node of the workloads and mark it `UnSchedulable`.

    `kubectl drain node01 --ignore-daemonsets`

13. Upgrade the worker node to the exact version v1.27.0

    On the node01 node, run the following commands:
        If you are on the `controlplane` node, run `ssh node01` to log in to the `node01`.
    This will update the package lists from the software repository.

    `apt-get update`

    This will install the kubeadm version 1.27.0.
    `apt-get install kubeadm=1.27.0-00`

    This will upgrade the node01 configuration.
    `kubeadm upgrade node`


    This will update the kubelet with the version 1.27.0.
    `apt-get install kubelet=1.27.0-00`

    You may need to reload the daemon and restart the kubelet service after it has been upgraded.
    ```
    systemctl daemon-reload
    systemctl restart kubelet
    ```

    Type exit or logout or enter CTRL + d to go back to the controlplane node.