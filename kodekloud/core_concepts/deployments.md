1. How many PODs exist on the system?

    `k get po`

2. How many ReplicaSets exist on the system?

    `k get rs`

3. How many Deployments exist on the system?

    `k get deploy`

4. How many Deployments exist on the system now?

    `k get deploy`

5. How many ReplicaSets exist on the system now?

    `k get rs`

6. How many PODs exist on the system now?

    `k get po --no-headers | wc -l`

7. Out of all the existing PODs, how many are ready?

    `k get deploy`

8. What is the image used to create the pods in the new deployment?

    `k describe deploy frontend-deployment  | grep Image`

9.  Why do you think the deployment is not ready?

    `Failed to pull image "busybox888": rpc error: code = Unknown desc = failed to pull and unpack image "docker.io/library/busybox888:latest": failed to resolve reference "docker.io/library/busybox888:latest": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed`

10. Create a new Deployment using the deployment-definition-1.yaml file located at /root/.

    `kubectl explain deployment | head -n1`

11. Create a new Deployment with the below attributes using your own deployment definition file.
    Name: httpd-frontend;
    Replicas: 3;
    Image: httpd:2.4-alpine

    `kubectl create deployment httpd-frontend --image=httpd:2.4-alpine --replicas=3`