1. A pod definition file nginx.yaml is given. Create a pod using the file.

    `kubectl create -f nginx.yaml`

2. What is the status of the created POD?

    `k get po`

3. Why is the POD in a pending state?

    Run the command: `kubectl get pods --namespace kube-system` to see the status of `scheduler` pod. We have removed the scheduler from this Kubernetes cluster. As a result, as it stands, the pod will remain in a pending state forever.

4. Manually schedule the pod on node01.


    Delete the existing pod first. Run the below command:

    `$ kubectl delete po nginx`
    To list and know the names of available nodes on the cluster:

    `$ kubectl get nodes`
    Add the `nodeName` field under the spec section in the nginx.yaml file with `node01` as the value:

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
    
    Then run the command `kubectl create -f nginx.yaml` to create a pod from the definition file.

    To check the status of a `nginx` pod and to know the node name: 

    `$ kubectl get pods -o wide`

5. Now schedule the same pod on the controlplane node.

    change nodeName: to controlplane
    `k get po -owide`