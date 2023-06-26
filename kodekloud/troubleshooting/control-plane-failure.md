1. The cluster is broken. We tried deploying an application but it's not working. Troubleshoot and fix the issue.

    Run the command: kubectl get pods -n kube-system and check the status of kube-scheduler pod.
    We need to check the kube-scheduler manifest file to fix the issue.



    The command run by the scheduler pod is incorrect. Here is a snippet of the YAML file.
    ```
    spec:
    containers:
    - command:
        - kube-schedulerrrrrrr
        - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
        - --authorization-kubeconfig=/etc/kubernetes/scheduler.conf
        - --bind-address=127.0.0.1
        - --kubeconfig=/etc/kubernetes/scheduler.conf
        - --leader-elect=true
        ....
    ```
    Once this is corrected, the scheduler pod will be recreated.

2. Scale the deployment app to 2 pods.

    `kubectl scale deploy app --replicas=2`
 
3. Even though the deployment was scaled to 2, the number of PODs does not seem to increase. Investigate and fix the issue. Inspect the component responsible for managing deployments and replicasets.

    Run the command: `kubectl get po -n kube-system` and check the logs of kube-controller-manager pod to know the failure reason by running command: `kubectl logs -n kube-system kube-controller-manager-controlplane`

    Then check the kube-controller-manager configuration file at /etc/kubernetes/manifests/kube-controller-manager.yaml and fix the issue.
    ```
    root@controlplane:/etc/kubernetes/manifests# kubectl -n kube-system logs kube-controller-manager-controlplane
    I0916 13:10:47.059336       1 serving.go:348] Generated self-signed cert in-memory
    stat /etc/kubernetes/controller-manager-XXXX.conf: no such file or directory

    root@controlplane:/etc/kubernetes/manifests# 
    The configuration file specified (/etc/kubernetes/controller-manager-XXXX.conf) does not exist.
    Correct the path: /etc/kubernetes/controller-manager.conf
    ```
    

4. Something is wrong with scaling again. We just tried scaling the deployment to 3 replicas. But it's not happening.

    Check the volume mount path in kube-controller-manager manifest file at /etc/kubernetes/manifests.
    Just as we did in the previous question, inspect the logs of the kube-controller-manager pod:
    ```
    root@controlplane:/etc/kubernetes/manifests# kubectl -n kube-system logs kube-controller-manager-controlplane
    I0916 13:17:27.452539       1 serving.go:348] Generated self-signed cert in-memory
    unable to load client CA provider: open /etc/kubernetes/pki/ca.crt: no such file or directory

    root@controlplane:/etc/kubernetes/manifests# 
    ```
    It appears the path /etc/kubernetes/pki is not mounted from the controlplane to the kube-controller-manager pod. If we inspect the pod manifest file, we can see that the incorrect hostPath is used for the volume:

    WRONG:
    ```

    - hostPath:
        path: /etc/kubernetes/WRONG-PKI-DIRECTORY
        type: DirectoryOrCreate
    ```
    CORRECT:
    ```

    - hostPath: 
        path: /etc/kubernetes/pki 
        type: DirectoryOrCreate 
    ```
    Once the path is corrected, the pod will be recreated and our deployment should eventually scale up to 3 replicas.
