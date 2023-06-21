1. How many pods exist on the system?

    `0`

2. Create a new pod with the nginx image.

    `kubectl run nginx --image=nginx`

3. How many pods are created now?

    `k get po --no-headers | wc -l`

4. What is the image used to create the new pods?

    `kubectl describe pod newpods-vk429  | grep Image`

5. Which nodes are these pods placed on?

    `k get po -o wide`

6. How many containers are part of the pod webapp?

    `kubectl describe pod webapp`

7. What images are used in the new webapp pod?

    `kubectl describe pod webapp`

8. What is the state of the container agentx in the pod webapp?

    `kubectl describe pod webapp`

9. Why do you think the container agentx in pod webapp is in error?

    `kubectl describe pod webapp` events section. Image does not exist.

10. What does the READY column in the output of the kubectl get pods command indicate?

    `kubectl get pods`

11. Delete the webapp Pod.

    `kubectl delete pod webapp`

12. Create a new pod with the name redis and the image redis123.

    We use `kubectl run command with --dry-run=client -o yaml` option to create a manifest file :-
    `kubectl run redis --image=redis123 --dry-run=client -o yaml > redis-definition.yaml`


    After that, using `kubectl create -f` command to create a resource from the manifest file :-

    `kubectl create -f redis-definition.yaml`
    Verify the work by running kubectl get command :-

    `kubectl get pods`

13. Now change the image on this pod to redis.

    `k edit pod redis` or edit the redis-definition.yaml and re-create the pod.