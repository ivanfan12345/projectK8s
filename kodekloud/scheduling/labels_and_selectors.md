1. A pod definition file nginx.yaml is given. Create a pod using the file.

    `kubectl create -f nginx.yaml`

2. What is the status of the created POD?

    `k get po`

3. Why is the POD in a pending state?

    `no scheduled available`
    `kubectl get pods --namespace kube-system`

4. Manually schedule the pod on node01.

    ```
    $ kubectl delete po nginx
    $ kubectl get nodes
    ```
    Add the nodeName field under the spec section in the nginx.yaml file with node01 as the value:
    ```
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: nginx
    spec:
    nodeName: node01
    containers:
    -  image: nginx
        name: nginx
    ```
    `kubectl create -f nginx.yaml`

5. Now schedule the same pod on the controlplane node.

    `Update nginx.yaml for nodeName: controlplane`