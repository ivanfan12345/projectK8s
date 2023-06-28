1. Inspect the kubelet service and identify the container runtime endpoint value is set for Kubernetes.

    Run the command: `ps -aux | grep kubelet | grep --color container-runtime-endpoint` and look at the configured --container-runtime-endpoint flag.
    ```
    controlplane ~ ➜  ps -aux | grep kubelet | grep --color container-runtime-endpoint
    root        4562  0.0  0.0 3700492 102052 ?      Ssl  12:36   0:08 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock --pod-infra-container-image=registry.k8s.io/pause:3.9
    ```


2. What is the path configured with all binaries of CNI supported plugins?

    The CNI binaries are located under `/opt/cni/bin` by default.


3. Identify which of the below plugins is not available in the list of available CNI plugins on this host?

    Run the command: `ls /opt/cni/bin` and identify the one not present at that directory.

4. What is the CNI plugin configured to be used on this kubernetes cluster?

    Run the command: `ls /etc/cni/net.d/` and identify the name of the plugin.

5. What binary executable file will be run by kubelet after a container and its associated namespace are created?

    Look at the type field in file `/etc/cni/net.d/10-flannel.conflist`.
    ```
    controlplane ~ ➜  cat /etc/cni/net.d/10-flannel.conflist 
    {
    "name": "cbr0",
    "cniVersion": "0.3.1",
    "plugins": [
        {
        "type": "flannel",
        "delegate": {
            "hairpinMode": true,
            "isDefaultGateway": true
        }
        },
        {
        "type": "portmap",
        "capabilities": {
            "portMappings": true
        }
        }
    ]
    }
    ```