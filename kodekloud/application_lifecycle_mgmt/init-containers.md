1. Identify the pod that has an initContainer configured.

    `k describe po blue | grep Init`

2. What is the image used by the initContainer on the blue pod?

    `kubectl describe pod blue`

3. What is the state of the initContainer on pod blue?

    Run the command `kubectl describe pod blue` and check the state field of the initContainer.

4. Why is the initContainer terminated? What is the reason?

    Check the Reason field for the initContainer in the `kubectl describe pod blue` command. This container was terminated after sleeping for 5 seconds.

5. We just created a new app named purple. How many initContainers does it have?

    `kubectl describe pod purple`

8. Update the pod red to use an initContainer that uses the busybox image and sleeps for 20 seconds.

    ```
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: red
    namespace: default
    spec:
    containers:
    - command:
        - sh
        - -c
        - echo The app is running! && sleep 3600
        image: busybox:1.28
        name: red-container
    initContainers:
    - image: busybox
        name: red-initcontainer
        command: 
        - "sleep"
        - "20"
    ```

9. A new application orange is deployed. There is something wrong with it. Identify and fix the issue.

    ```
    controlplane ~ ➜  k describe po orange
    Name:             orange
    Namespace:        default
    Priority:         0
    Service Account:  default
    Node:             controlplane/192.23.43.9
    Start Time:       Sat, 24 Jun 2023 17:05:14 +0000
    Labels:           <none>
    Annotations:      <none>
    Status:           Pending
    IP:               10.42.0.14
    IPs:
    IP:  10.42.0.14
    Init Containers:
    init-myservice:
        Container ID:  containerd://cf5ae4412eb4362131b4f27a4ba512b4bb587008efb6d45a8d8c81cc08eb3d79
        Image:         busybox
        Image ID:      docker.io/library/busybox@sha256:6e494387c901caf429c1bf77bd92fb82b33a68c0e19f6d1aa6a3ac8d27a7049d
        Port:          <none>
        Host Port:     <none>
        Command:
        sh
        -c
        sleeeep 2;
        State:          Terminated
        Reason:       Error
        Exit Code:    127
    ```

    There is a typo in the command used by the initContainer. To fix this, first get the pod definition file by running `kubectl get pod orange -o yaml > /root/orange.yaml`.
    Next, edit the command and fix the typo.
    Then, delete the old pod by running `kubectl delete pod orange`
    Finally, create the pod again by running `kubectl create -f /root/orange.yaml`




10.



