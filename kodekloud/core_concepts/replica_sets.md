1. How many PODs exist on the system?

    `k get po`

2. How many ReplicaSets exist on the system?

    `k get rs`

3. How about now? How many ReplicaSets do you see?

    `k get rs`

4. How many PODs are DESIRED in the new-replica-set?

    `k get pods --no-headers | wc -l`

5. What is the image used to create the pods in the new-replica-set?

    `k describe po new-replica-set-kkxgx  | grep Image`

6. How many PODs are READY in the new-replica-set?

    `k get po`

7. Why do you think the PODs are not ready?

    `k describe po <pod_name>` Check Events.

8. Delete any one of the 4 PODs.

    `k delete po <pod_name>`

9. How many PODs exist now?

    `k get po`

10. Why are there still 4 PODs, even after you deleted one?

    ReplicaSet ensures that desired number of PODs always run

11. Create a ReplicaSet using the replicaset-definition-1.yaml file located at /root/.

    `kubectl explain replicaset | grep VERSION`

12.  Fix the issue in the replicaset-definition-2.yaml file and create a ReplicaSet using it.

    ```
    ---
    apiVersion: apps/v1
    kind: ReplicaSet
    metadata:
    name: replicaset-2
    spec:
    replicas: 2
    selector:
        matchLabels:
        tier: nginx
    template:
        metadata:
        labels:
            tier: nginx
        spec:
        containers:
        - name: nginx
            image: nginx
    ```

13. Delete the two newly created ReplicaSets - replicaset-1 and replicaset-2

    `k get rs`
    `k delete rs replicaset-1`
    `k delete rs replicaset-2`

13. Fix the original replica set new-replica-set to use the correct busybox image.

    `k edit rs new-replica-set` change image to busybox. Then delete existing pods.

14. Scale the ReplicaSet to 5 PODs.

    `kubectl edit replicaset new-replica-set` 
    or
    `kubectl scale rs new-replica-set --replicas=5`

15. Now scale the ReplicaSet down to 2 PODs.
    `kubectl edit replicaset new-replica-set`
    or
    `kubectl scale rs new-replica-set --replicas=2`
