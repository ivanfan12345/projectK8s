1. Fix the broken cluster

    Step1: Check the status of the nodes:

    ```
    controlplane:~> kubectl get nodes
    NAME           STATUS     ROLES           AGE     VERSION
    controlplane   Ready      control-plane   5m43s   v1.26.0
    node01         NotReady   <none>          5m7s    v1.26.0

    controlplane:~> 
    ```


    Step 2: SSH to node01 and check the status of the container runtime (containerd, in this case) and the kubelet service.



    ```
    root@node01:~> systemctl status containerd
    ● containerd.service - containerd container runtime
        Loaded: loaded (/lib/systemd/system/containerd.service; enabled; vendor preset: enabled)
        Active: active (running) since Thu 2022-12-29 14:50:26 EST; 11min ago
        Docs: https://containerd.io
    Main PID: 1058 (containerd)
        Tasks: 65
        Memory: 181.2M
        CGroup: /system.slice/containerd.service

    root@node01:~>

    root@node01:~> systemctl status kubelet
    ● kubelet.service - kubelet: The Kubernetes Node Agent
        Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
        Drop-In: /etc/systemd/system/kubelet.service.d
                └─10-kubeadm.conf
        Active: inactive (dead) since Thu 2022-12-29 14:51:58 EST; 7min ago
        Docs: https://kubernetes.io/docs/home/
        Process: 2085 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTR>
    Main PID: 2085 (code=exited, status=0/SUCCESS)
    ```


    Since the kubelet is not running, attempt to start it by running the following command:

    ```
    root@node01:~> systemctl start kubelet

    root@node01:~> systemctl status kubelet
    ● kubelet.service - kubelet: The Kubernetes Node Agent
        Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
        Drop-In: /etc/systemd/system/kubelet.service.d
                └─10-kubeadm.conf
        Active: active (running) since Thu 2022-12-29 15:00:26 EST; 3s ago
        Docs: https://kubernetes.io/docs/home/
    ```


    node01 should go back to ready state now.


    Step1: Check the status of the nodes:


    ```
    controlplane:~> kubectl get nodes
    NAME           STATUS     ROLES           AGE   VERSION
    controlplane   Ready      control-plane   19m   v1.27.0
    node01         NotReady   <none>          19m   v1.27.0

    controlplane:~> 
    ```


    Step 2: SSH to node01 and check the status of the container runtime (containerd, in this case) and the kubelet service.



    ```
    root@node01:~> systemctl status containerd
    ● containerd.service - containerd container runtime
        Loaded: loaded (/lib/systemd/system/containerd.service; enabled; vendor preset: enabled)
        Active: active (running) since Tue 2023-05-30 12:45:03 EDT; 20min ago
        Docs: https://containerd.io
    Main PID: 995 (containerd)
        Tasks: 100
        Memory: 146.8M
        CGroup: /system.slice/containerd.service
                ├─ 995 /usr/bin/containerd

    root@node01:~>

    root@node01:~> systemctl status kubelet
    ● kubelet.service - kubelet: The Kubernetes Node Agent
        Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
        Drop-In: /etc/systemd/system/kubelet.service.d
                └─10-kubeadm.conf
        Active: inactive (dead) since Tue 2023-05-30 12:47:30 EDT; 18min ago
        Docs: https://kubernetes.io/docs/home/
        Process: 1978 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS (code=exited, status=0/S>
    Main PID: 1978 (code=exited, status=0/SUCCESS)
    ```


    Since the kubelet is not running, attempt to start it by running the following command:

    ```
    root@node01:~> systemctl start kubelet

    root@node01:~> systemctl status kubelet
    ● kubelet.service - kubelet: The Kubernetes Node Agent
        Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
        Drop-In: /etc/systemd/system/kubelet.service.d
                └─10-kubeadm.conf
        Active: active (running) since Tue 2023-05-30 13:06:47 EDT; 6s ago
        Docs: https://kubernetes.io/docs/home/
    Main PID: 4313 (kubelet)
        Tasks: 15 (limit: 77091)
        Memory: 31.4M
        CGroup: /system.slice/kubelet.service
    ```


    node01 should go back to ready state now.

2. The cluster is broken again. Investigate and fix the issue.

    Inspect the logs using `journalctl -u kubelet -f`. Fix the issue in the file.

    kubelet has stopped running on node01 again. Since this is a systemd managed system, we can check the kubelet log by running journalctl command. Here is a snippet showing the error with kubelet:
    ```
    root@node01:~# journalctl -u kubelet 
    .
    .
    May 30 13:08:20 node01 kubelet[4554]: E0530 13:08:20.141826    4554 run.go:74] "command failed" err="failed to construct kubelet dependencies: unable to load client CA file /etc/kubernetes/pki/WRONG-CA-FILE.crt: open /etc/kubernetes/pki/WRONG-CA-FILE.crt: no such file or directory"
    .
    .
    ```


    There appears to be a mistake path used for the CA certificate in the kubelet configuration.

    This can be corrected by updating the file /var/lib/kubelet/config.yaml as follows: -
    ```

    x509:
        clientCAFile: /etc/kubernetes/pki/WRONG-CA-FILE.crt
    ```


    Update the CA certificate file WRONG-CA-FILE.crt to ca.crt.

    Once this is fixed, restart the kubelet service, (like we did in the previous question) and node01 should return back to a working state.


    

3. Once again the kubelet service has stopped working. Checking the logs, we can see that this time, it is not able to reach the kube-apiserver.



    root@node01:~# journalctl -u kubelet 
    .
    .
    .
    May 30 13:43:55 node01 kubelet[8858]: E0530 13:43:55.004939    8858 reflector.go:148] vendor/k8s.io/client-go/informers/factory.go:150: Failed to watch *v1.Node: failed to list *v1.Node: Get "https://controlplane:6553/api/v1/nodes?fieldSelector=metadata.name%3Dnode01&limit=500&resourceVersion=0": dial tcp 192.24.132.5:6553: connect: connection refused
    .
    .
    .


    As we can clearly see, kubelet is trying to connect to the API server on the controlplane node on port 6553. This is incorrect.
    To fix, correct the port on the kubeconfig file used by the kubelet.

    apiVersion: v1
    clusters:
    - cluster:
        certificate-authority-data:
        --REDACTED---
        server: https://controlplane:6443


    Restart the kubelet service after this change.

    systemctl restart kubelet
