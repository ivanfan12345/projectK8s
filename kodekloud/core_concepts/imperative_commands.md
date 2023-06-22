1. Deploy a pod named nginx-pod using the nginx:alpine image.

    `k run nginx-pod --image=nginx:alpine`

2. Deploy a redis pod using the redis:alpine image with the labels set to tier=db.

    `kubectl run redis --image=redis:alpine --dry-run=client -oyaml > redis-pod.yaml` Add given labels tier=db under the metadata section.

    ```
    ---
    apiVersion: v1
    kind: Pod
    metadata:
    labels:
        tier: db
    name: redis
    spec:
    containers:
    - image: redis:alpine
        name: redis
    dnsPolicy: ClusterFirst
    restartPolicy: Always
    ```
    Then run the command: kubectl create -f redis-pod.yaml to create the pod from the definition file. OR Use the imperative command:
    `kubectl run redis -l tier=db --image=redis:alpine`

3. Create a service redis-service to expose the redis application within the cluster on port 6379.

    `kubectl expose pod redis --port=6379 --name redis-service`

4. Create a deployment named webapp using the image kodekloud/webapp-color with 3 replicas.

    `kubectl create deployment webapp --image=kodekloud/webapp-color --replicas=3`

6. Create a new pod called custom-nginx using the nginx image and expose it on container port 8080.

    `kubectl run custom-nginx --image=nginx --port=8080`

7. Create a new namespace called dev-ns.

    `kubectl create ns dev-ns`

8. Create a new deployment called redis-deploy in the dev-ns namespace with the redis image. It should have 2 replicas.

    `k create deploy redis-deploy --image=redis --replicas=2 -n dev-ns`

9. Create a pod called httpd using the image httpd:alpine in the default namespace. Next, create a service of type ClusterIP by the same name (httpd). The target port for the service should be 80.

    `kubectl run httpd --image=httpd:alpine --port=80 --expose`
