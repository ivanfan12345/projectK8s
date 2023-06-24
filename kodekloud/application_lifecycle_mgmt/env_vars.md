1. How many PODs exist on the system?

    `k get po`

2. What is the environment variable name set on the container in the pod?

    `kubectl describe pod`

3. What is the value set on the environment variable APP_COLOR on the container in the pod?

    `Run the command `kubectl describe pod` and look for the `Environment` option.

5. Update the environment variable on the POD to display a green background.

    ```
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    labels:
        name: webapp-color
    name: webapp-color
    namespace: default
    spec:
    containers:
    - env:
        - name: APP_COLOR
        value: green
        image: kodekloud/webapp-color
        name: webapp-color
    ```
    
6. Update the environment variable on the POD to display a green background.

7. How many ConfigMaps exists in the default namespace?

    `k get cm`

8. Identify the database host from the config map `db-config`.

    `k describe cm db-config`

9. Create a new ConfigMap for the webapp-color POD. Use the spec given below.

    ConfigMap Name: webapp-config-map
    Data: APP_COLOR=darkblue
    Data: APP_OTHER=disregard

    `kubectl create configmap webapp-config-map --from-literal=APP_COLOR=darkblue --from-literal=APP_OTHER=disregard`

10. Update the environment variable on the POD to use only the APP_COLOR key from the newly created ConfigMap. Note: Delete and recreate the POD. Only make the necessary changes. Do not modify the name of the Pod.

    ```
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    labels:
        name: webapp-color
    name: webapp-color
    namespace: default
    spec:
    containers:
    - env:
        - name: APP_COLOR
        valueFrom:
        configMapKeyRef:
            name: webapp-config-map
            key: APP_COLOR
        image: kodekloud/webapp-color
        name: webapp-color
    ```


