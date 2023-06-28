1. What is the user used to execute the sleep process within the ubuntu-sleeper pod?

    `kubectl exec ubuntu-sleeper -- whoami` == `root`

2. Edit the pod ubuntu-sleeper to run the sleep process with user ID 1010. Note: Only make the necessary changes. Do not modify the name or image of the pod.

    To delete the existing ubuntu-sleeper pod:

    `kubectl delete po ubuntu-sleeper `
    After that apply solution manifest file to run as user 1010 as follows:
    ```
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: ubuntu-sleeper
    namespace: default
    spec:
    securityContext:
        runAsUser: 1010
    containers:
    - command:
        - sleep
        - "4800"
        image: ubuntu
        name: ubuntu-sleeper
    ```
    Then run the command kubectl apply -f <file-name>.yaml to create a resource.

    NOTE: TO delete the pod faster, you can run `kubectl delete pod ubuntu-sleeper --force`. This can be done for any pod in the lab or the actual exam. It is not recommended to run this in Production, so keep a note of that.

3. A Pod definition file named multi-pod.yaml is given. With what user are the processes in the web container started? The pod is created with multiple containers and security contexts defined at the Pod and Container level.

    The User ID defined in the securityContext of the container overrides the User ID in the POD.
    ```
     cat multi-pod.yaml 
    apiVersion: v1
    kind: Pod
    metadata:
    name: multi-pod
    spec:
    securityContext:
        runAsUser: 1001
    containers:
    -  image: ubuntu
        name: web
        command: ["sleep", "5000"]
        securityContext:
        runAsUser: 1002

    -  image: ubuntu
        name: sidecar
        command: ["sleep", "5000"]
    ```

4. With what user are the processes in the sidecar container started?

    The User ID defined in the securityContext of the POD is carried over to all the containers in the Pod. `1001`

5. Update pod ubuntu-sleeper to run as Root user and with the SYS_TIME capability.

    
    Pod Name: ubuntu-sleeper
    Image Name: ubuntu
    SecurityContext: Capability SYS_TIME
    Is run as a root user?

    To delete the existing pod:

    `kubectl delete po ubuntu-sleeper`
    After that apply solution manifest file to add capabilities in ubuntu-sleeper pod:
    ```
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: ubuntu-sleeper
    namespace: default
    spec:
    containers:
    - command:
        - sleep
        - "4800"
        image: ubuntu
        name: ubuntu-sleeper
        securityContext:
        capabilities:
            add: ["SYS_TIME"]
    ```
    Then run the command `kubectl apply -f <file-name>.yaml` to create a pod from given definition file.

6. Now update the pod to also make use of the NET_ADMIN capability.

    ```
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    name: ubuntu-sleeper
    namespace: default
    spec:
    containers:
    - command:
        - sleep
        - "4800"
        image: ubuntu
        name: ubuntu-sleeper
        securityContext:
        capabilities:
            add: ["SYS_TIME","NET_ADMIN"]
    ```

7.

    

8.

    

9.

    

10.

