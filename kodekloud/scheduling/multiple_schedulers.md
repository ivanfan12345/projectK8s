1. What is the name of the POD that deploys the default kubernetes scheduler in this environment?

    `kubectl get pods --namespace=kube-system`

3. We have already created the ServiceAccount and ClusterRoleBinding that our custom scheduler will make use of.


    Checkout the following Kubernetes objects:

    ServiceAccount: my-scheduler (kube-system namespace)
    ClusterRoleBinding: my-scheduler-as-kube-scheduler
    ClusterRoleBinding: my-scheduler-as-volume-scheduler


    Run the command: kubectl get serviceaccount -n kube-system and kubectl get clusterrolebinding


    Note: - Don't worry if you are not familiar with these resources. We will cover it later on.

4. Let's create a configmap that the new scheduler will employ using the concept of ConfigMap as a volume.

    We have already given a configMap definition file called my-scheduler-configmap.yaml at /root/ path that will create a configmap with name my-scheduler-config using the content of file /root/my-scheduler-config.yaml.

    `kubectl create -f /root/my-scheduler-configmap.yaml`

5. Deploy an additional scheduler to the cluster following the given specification.

    Use the manifest file provided at /root/my-scheduler.yaml. Use the same image as used by the default kubernetes scheduler.

6. A POD definition file is given. Use it to create a POD with the new custom scheduler.

    File is located at /root/nginx-pod.yaml

        ```
        ---
        apiVersion: v1 
        kind: Pod 
        metadata:
        name: nginx 
        spec:
        schedulerName: my-scheduler
        containers:
        - image: nginx
            name: nginx
        ```