1. How many Labels exist on node node01?

    `kubectl describe node node01`

2. What is the value set to the label key beta.kubernetes.io/arch on node01?

    `kubectl get node node01 --show-labels`

3. Apply a label color=blue to node node01

    `kubectl label node node01 color=blue`

4. Create a new deployment named blue with the nginx image and 3 replicas.

    `kubectl create deployment blue --image=nginx --replicas=3`

5. Which nodes can the pods for the blue deployment be placed on?

    Check if controlplane and node01 have any taints on them that will prevent the pods to be scheduled on them. If there are no taints, the pods can be scheduled on either node.

    So run the following command to check the taints on both nodes.

    `kubectl describe node controlplane | grep -i taints`

    `kubectl describe node node01 | grep -i taints`

6. Set Node Affinity to the deployment to place the pods on node01 only.

    `k edit deploy <deploy_name>`

    ```
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: blue
    spec:
    replicas: 3
    selector:
        matchLabels:
        run: nginx
    template:
        metadata:
        labels:
            run: nginx
        spec:
        containers:
        - image: nginx
            imagePullPolicy: Always
            name: nginx
        affinity:
            nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                - key: color
                    operator: In
                    values:
                    - blue
    ```

8. Create a new deployment named red with the nginx image and 2 replicas, and ensure it gets placed on the controlplane node only.

Use the label key - node-role.kubernetes.io/control-plane - which is already set on the controlplane node.

    ```
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: red
    spec:
    replicas: 2
    selector:
        matchLabels:
        run: nginx
    template:
        metadata:
        labels:
            run: nginx
        spec:
        containers:
        - image: nginx
            imagePullPolicy: Always
            name: nginx
        affinity:
            nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
    ```