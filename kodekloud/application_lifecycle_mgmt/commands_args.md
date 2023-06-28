1. How many PODs exist on the system?

    `k get po`

2.  What is the command used to run the pod ubuntu-sleeper?

    `kubectl describe pod`

3.  Create a pod with the ubuntu image to run a container to sleep for 5000 seconds. Modify the file ubuntu-sleeper-2.yaml.

    ```
    ---
    apiVersion: v1 
    kind: Pod 
    metadata:
    name: ubuntu-sleeper-2 
    spec:
    containers:
    - name: ubuntu
        image: ubuntu
        command:
        - "sleep"
        - "5000"
      ```

4. Create a pod using the file named ubuntu-sleeper-3.yaml. There is something wrong with it. Try to fix it!

    ```
    ---
    apiVersion: v1 
    kind: Pod 
    metadata:
    name: ubuntu-sleeper-3 
    spec:
    containers:
    - name: ubuntu
        image: ubuntu
        command:
        - "sleep"
        - "1200"
    ```

5. Update pod ubuntu-sleeper-3 to sleep for 2000 seconds.

6. Inspect the file Dockerfile given at `/root/webapp-color directory`. What command is run at container startup?

    `Inspect the ENTRYPOINT in the Dockerfile.`

10. Create a pod with the given specifications. By default it displays a blue background. Set the given command line arguments to change it to green.

    ```
    ---
    apiVersion: v1 
    kind: Pod 
    metadata:
    name: webapp-green
    labels:
        name: webapp-green 
    spec:
    containers:
    - name: simple-webapp
        image: kodekloud/webapp-color
        args: ["--color", "green"]
    ```