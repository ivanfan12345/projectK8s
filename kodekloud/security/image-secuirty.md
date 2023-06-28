1. What secret type must we choose for docker registry?

    `kubectl create secret --help`

2. We have an application running on our cluster. Let us explore it first. What image is the application using?

    `k describe deploy web`

3. We decided to use a modified version of the application from an internal private registry. Update the image of the deployment to use a new image from myprivateregistry.com:5000 The registry is located at myprivateregistry.com:5000. Don't worry about the credentials for now. We will configure them in the upcoming steps.

    Use the kubectl edit deployment command to edit the image name to myprivateregistry.com:5000/nginx:alpine.

4. Are the new PODs created with the new images successfully running?

    `k get po`

5. Create a secret object with the credentials required to access the registry.
    Name: private-reg-cred
    Username: dock_user
    Password: dock_password
    Server: myprivateregistry.com:5000
    Email: dock_user@myprivateregistry.com

    Run the command: `kubectl create secret docker-registry private-reg-cred --docker-username=dock_user --docker-password=dock_password --docker-server=myprivateregistry.com:5000 --docker-email=dock_user@myprivateregistry.com`

6. Configure the deployment to use credentials from the new secret to pull images from the private registry

    Update deploy with spec section:
    ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    annotations:
        deployment.kubernetes.io/revision: "3"
    creationTimestamp: "2023-06-25T02:13:08Z"
    generation: 3
    labels:
        app: web
    name: web
    namespace: default
    resourceVersion: "5030"
    uid: 9e43b081-4e21-4318-a15b-721b4be64a84
    spec:
    progressDeadlineSeconds: 600
    replicas: 2
    revisionHistoryLimit: 10
    selector:
        matchLabels:
        app: web
    strategy:
        rollingUpdate:
        maxSurge: 25%
        maxUnavailable: 25%
        type: RollingUpdate
    template:
        metadata:
        creationTimestamp: null
        labels:
            app: web
        spec:
        containers:
        - image: myprivateregistry.com:5000/nginx:alpine
            imagePullPolicy: IfNotPresent
            name: nginx
            resources: {}
            terminationMessagePath: /dev/termination-log
            terminationMessagePolicy: File
        dnsPolicy: ClusterFirst
        imagePullSecrets:
        - name: private-reg-cred
        restartPolicy: Always
        schedulerName: default-scheduler
        securityContext: {}
        terminationGracePeriodSeconds: 30
    status:
    availableReplicas: 2
    conditions:
    - lastTransitionTime: "2023-06-25T02:13:12Z"
        lastUpdateTime: "2023-06-25T02:13:12Z"
        message: Deployment has minimum availability.
        reason: MinimumReplicasAvailable
        status: "True"
        type: Available
    - lastTransitionTime: "2023-06-25T02:13:08Z"
        lastUpdateTime: "2023-06-25T02:31:22Z"
        message: ReplicaSet "web-5999cdc98b" has successfully progressed.
        reason: NewReplicaSetAvailable
        status: "True"
        type: Progressing
    observedGeneration: 3
    readyReplicas: 2
    replicas: 2
    updatedReplicas: 2
    ```

    

7.

    

8.

    

9.

    

10.

