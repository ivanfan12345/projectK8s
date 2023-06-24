1. Identify the number of containers created in the red pod.

    `kubectl get pods`

2. Identify the name of the containers running in the blue pod.

    `k describe po blue`

3. Create a multi-container pod with 2 containers. Use the spec given below.

    If the pod goes into the crashloopbackoff then add the command sleep 1000 in the lemon container.

    Name: yellow
    Container 1 Name: lemon
    Container 1 Image: busybox
    Container 2 Name: gold
    Container 2 Image: redis

    ```
    apiVersion: v1
    kind: Pod
    metadata:
    name: yellow
    spec:
    containers:
    - name: lemon
        image: busybox
        command:
        - sleep
        - "1000"

    - name: gold
        image: redis
    ```

5. Once the pod is in a ready state, inspect the Kibana UI using the link above your terminal. There shouldn't be any logs for now.

    We will configure a sidecar container for the application to send logs to Elastic Search.
    NOTE: It can take a couple of minutes for the Kibana UI to be ready after the Kibana pod is ready.
    You can inspect the Kibana logs by running:
    `kubectl -n elastic-stack logs kibana`

6. Inspect the app pod and identify the number of containers in it.

    `kubectl describe pod app -n elastic-stack`

7. The application outputs logs to the file /log/app.log. View the logs and try to identify the user having issues with Login. Inspect the log file inside the pod.

    `kubectl -n elastic-stack exec -it app -- cat /log/app.log`

8. Edit the pod to add a sidecar container to send logs to Elastic Search. Mount the log volume to the sidecar container.

    Only add a new container. Do not modify anything else. Use the spec provided below.

    Note: State persistence concepts are discussed in detail later in this course. For now please make use of the below documentation link for updating the concerning pod.

    https://kubernetes.io/docs/tasks/access-application-cluster/communicate-containers-same-pod-shared-volume/


    Name: app
    Container Name: sidecar
    Container Image: kodekloud/filebeat-configured
    Volume Mount: log-volume
    Mount Path: /var/log/event-simulator/
    Existing Container Name: app
    Existing Container Image: kodekloud/event-simulator

    ```
    apiVersion: v1
    kind: Pod
    metadata:
    name: app
    namespace: elastic-stack
    labels:
        name: app
    spec:
    containers:
    - name: app
        image: kodekloud/event-simulator
        volumeMounts:
        - mountPath: /log
        name: log-volume

    - name: sidecar
        image: kodekloud/filebeat-configured
        volumeMounts:
        - mountPath: /var/log/event-simulator/
        name: log-volume

    volumes:
    - name: log-volume
        hostPath:
        # directory location on host
        path: /var/log/webapp
        # this field is optional
        type: DirectoryOrCreate
    ```