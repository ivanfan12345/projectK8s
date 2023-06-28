1. In this practice test we will install weave-net POD networking solution to the cluster. Let us first inspect the setup. We have deployed an application called app in the default namespace. What is the state of the pod?

    `k get po`

2. Inspect why the POD is not running.

    `k describe po app`: No Network Configured

3. Deploy weave-net networking solution to the cluster. NOTE: - We already have provided a weave manifest file under the /root/weave directory.

    Run the below command to deploy the weave on the cluster: -

    `kubectl apply -f /root/weave/weave-daemonset-k8s.yaml`
    Now check if the weave pods are created and let's also check the status of our app pod now:
    ```
    root@controlplane:/# kubectl get pods -A | grep weave
    kube-system   weave-net-q7m6s                        2/2     Running   0          21s

    root@controlplane:/# kubectl get pods
    NAMESPACE     NAME                                   READY   STATUS              RESTARTS   AGE
    default       app                                    0/1     ContainerCreating   0          3m47s
    kube-system   coredns-5d78c9869d-6ljbq               1/1     Running             0          46m
    kube-system   coredns-5d78c9869d-rklbn               1/1     Running             0          46m
    kube-system   etcd-controlplane                      1/1     Running             0          46m
    kube-system   kube-apiserver-controlplane            1/1     Running             0          46m
    kube-system   kube-controller-manager-controlplane   1/1     Running             0          46m
    kube-system   kube-proxy-6smkz                       1/1     Running             0          46m
    kube-system   kube-scheduler-controlplane            1/1     Running             0          46m
    kube-system   weave-net-kh88n                        2/2     Running             0          15s
    ```