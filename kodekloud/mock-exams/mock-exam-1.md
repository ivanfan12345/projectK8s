1. Deploy a pod named nginx-pod using the nginx:alpine image.

    Once done, click on the Next Question button in the top right corner of this panel. You may navigate back and forth freely between all questions. Once done with all questions, click on End Exam. Your work will be validated at the end and score shown. Good Luck!

    `kubectl run nginx-pod --image=nginx:alpine`

2. Deploy a messaging pod using the redis:alpine image with the labels set to tier=msg.

    `kubectl run messaging --image=redis:alpine --labels="tier=msg"`

3. Create a namespace named apx-x9984574.

    `k create ns apx-x9984574`

4. Get the list of nodes in JSON format and store it in a file at `/opt/outputs/nodes-z3444kd9.json`.

    `k get no -ojson > /opt/outputs/nodes-z3444kd9.json`

5. Create a service messaging-service to expose the messaging application within the cluster on port 6379. Use imperative commands.

    Service: messaging-service
    Port: 6379
    Type: ClusterIp
    Use the right labels
    ```
    kubectl expose pod messaging --port=6379 --name messaging-service
    ```

6. Create a deployment named hr-web-app using the image kodekloud/webapp-color with 2 replicas.

    Name: hr-web-app
    Image: kodekloud/webapp-color
    Replicas: 2

    `kubectl create deployment hr-web-app --image=kodekloud/webapp-color --replicas=2`

7. Create a static pod named static-busybox on the controlplane node that uses the busybox image and the command sleep 1000.

    Name: static-busybox
    Image: busybox

    ```
    /etc/kubernetes/manifests ➜  cat static-ivan-pod.yaml 
    apiVersion: v1
    kind: Pod
    metadata:
    creationTimestamp: null
    labels:
        run: static-busybox
    name: static-busybox
    spec:
    containers:
    - image: busybox
        name: static-busybox
        command: ['sh', '-c', 'sleep 1000']
        resources: {}
    dnsPolicy: ClusterFirst
    restartPolicy: Always
    status: {}
    ```

8. Create a POD in the finance namespace named temp-bus with the image redis:alpine.

    Name: temp-bus
    Image Name: redis:alpine

    `k run temp-bus --image=redis:alpine -n finance`

9. A new application orange is deployed. There is something wrong with it. Identify and fix the issue.

    Fix `sleeeeep` command:
    ```
    k get po orange -oyaml
    apiVersion: v1
    kind: Pod
    metadata:
    creationTimestamp: "2023-06-30T02:39:18Z"
    name: orange
    namespace: default
    resourceVersion: "5656"
    uid: 3bb8f533-8223-484c-a568-916821439a63
    spec:
    containers:
    - command:
        - sh
        - -c
        - echo The app is running! && sleep 3600
        image: busybox:1.28
        imagePullPolicy: IfNotPresent
        name: orange-container
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
        volumeMounts:
        - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
        name: kube-api-access-82rmk
        readOnly: true
    dnsPolicy: ClusterFirst
    enableServiceLinks: true
    initContainers:
    - command:
        - sh
        - -c
        - sleeeep 2;
        image: busybox
        imagePullPolicy: Always
        name: init-myservice
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
    ```
    A new application orange is deployed. There is something wrong with it. Identify and fix the issue.



10. Expose the hr-web-app as service hr-web-app-service application on port 30082 on the nodes on the cluster.

    The web application listens on port 8080.

    Name: hr-web-app-service
    Type: NodePort
    Endpoints: 2
    Port: 8080
    NodePort: 30082

    Run the command: `kubectl expose deployment hr-web-app --type=NodePort --port=8080 --name=hr-web-app-service --dry-run=client -o yaml > hr-web-app-service.yaml` to generate a service definition file.

    Now, in generated service definition file add the `nodePort` field with the given port number under the ports section and create a service.

11. Use JSON PATH query to retrieve the osImages of all the nodes and store it in a file /opt/outputs/nodes_os_x43kj56.txt.

    The osImages are under the nodeInfo section under status of each node.

    `k get no -ojsonpath="{.items[*].status.nodeInfo.osImage}" > /opt/outputs/nodes_os_x43kj56.txt`

12. Create a `Persistent Volume` with the given specification: -

    Volume name: `pv-analytics`
    Storage: `100Mi`
    Access mode: `ReadWriteMany`
    Host path: `/pv/data-analytics`

    Is the volume name set?
    Is the storage capacity set?
    Is the accessMode set?
    Is the hostPath set?os