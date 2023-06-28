1. We have deployed a POD. Inspect the POD and wait for it to start running.

    `k get po`

2. The application stores logs at location /log/app.log. View the logs.

    `kubectl exec webapp -- cat /log/app.log`

3. If the POD was to get deleted now, would you be able to view these logs.

    Use the command kubectl delete to delete a webapp pod and try to view those logs again. The logs are stored in the Container's file system that lives only as long as the Container does. Once the pod is destroyed, you cannot view the logs again. (NO)

4. Configure a volume to store these logs at /var/log/webapp on the host.

    Name: webapp
    Image Name: kodekloud/event-simulator
    Volume HostPath: /var/log/webapp
    Volume Mount: /log
    
    Use the command kubectl get po webapp -o yaml > webapp.yaml and add the given properties under the spec.volumes and spec.containers.volumeMounts.

    OR

    Use the command kubectl run to create a new pod and use the flag --dry-run=client -o yaml to generate the manifest file.

    In the manifest file add spec.volumes and spec.containers.volumeMounts property.



    After that, run the following command to create a pod called webapp: -

    `kubectl replace -f webapp.yaml --force`


    kubectl replace -f: - It will remove the existing resource and will replace it with the new one from the given manifest file.

    First delete the existing pod by running the following command: -

    `kubectl delete po webapp`
    then use the below manifest file to create a webapp pod with given properties as follows:
    ```
    apiVersion: v1
    kind: Pod
    metadata:
    name: webapp
    spec:
    containers:
    - name: event-simulator
        image: kodekloud/event-simulator
        env:
        - name: LOG_HANDLERS
        value: file
        volumeMounts:
        - mountPath: /log
        name: log-volume

    volumes:
    - name: log-volume
        hostPath:
        # directory location on host
        path: /var/log/webapp
        # this field is optional
        type: Directory
    ```
    Then run the command kubectl create -f <file-name>.yaml to create a pod.

5. Create a `Persistent Volume` with the given specification.

    Volume Name: pv-log
    Storage: 100Mi
    Access Modes: ReadWriteMany
    Host Path: /pv/log
    Reclaim Policy: Retain
    
    Use the following manifest file to create a pv-log persistent volume:
    ```
    apiVersion: v1
    kind: PersistentVolume
    metadata:
    name: pv-log
    spec:
    persistentVolumeReclaimPolicy: Retain
    accessModes:
        - ReadWriteMany
    capacity:
        storage: 100Mi
    hostPath:
        path: /pv/log
    ```
    Then run the command `kubectl create -f <file-name>.yaml` to create a PV from manifest file. `k get pv`

6. Let us claim some of that storage for our application. Create a Persistent Volume Claim with the given specification.

    Volume Name: claim-log-1
    Storage Request: 50Mi
    Access Modes: ReadWriteOnce

    Solution manifest file to create a claim-log-1 PVC with given properties as follows:
    ```
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
    name: claim-log-1
    spec:
    accessModes:
        - ReadWriteOnce
    resources:
        requests:
        storage: 50Mi
    ```
    Then run` kubectl create -f <file-name>.yaml` to create a PVC from the manifest file. `k get pvc`

7. What is the state of the Persistent Volume Claim?

    `k get pvc`

8. What is the state of the Persistent Volume?

    `k get pv`

9. Why is the claim not bound to the available Persistent Volume?

    Run the command: `kubectl get pv,pvc` and look at the Access Modes. The Access Modes set on the PV and the PVC do not match.

10. Update the Access Mode on the claim to bind it to the PV. Delete and recreate the claim-log-1.

    Volume Name: claim-log-1
    Storage Request: 50Mi
    PVol: pv-log
    Status: Bound

    Set the Access Mode on the PVC to ReadWriteMany.

    To delete the existing pvc:

    `$ kubectl delete pvc claim-log-1`
    Solution manifest file to create a claim-log-1 PVC with correct Access Modes as follows:
    ```
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
    name: claim-log-1
    spec:
    accessModes:
        - ReadWriteMany
    resources:
        requests:
        storage: 50Mi
    ```
    Then run `kubectl create -f <file-name>.yaml`

11. You requested for 50Mi, how much capacity is now available to the PVC?

    Run the command: kubectl get pvc and look under the capacity section.

12. Update the webapp pod to use the persistent volume claim as its storage. Replace hostPath configured earlier with the newly created PersistentVolumeClaim.

    Name: webapp
    Image Name: kodekloud/event-simulator
    Volume: PersistentVolumeClaim=claim-log-1
    Volume Mount: /log

    To delete the webapp pod first:

    `$ kubectl delete po webapp`
    Add --force flag in above command, if you would like to delete the pod without any delay.

    To create a new webapp pod with given properties as follows:
    ```
    apiVersion: v1
    kind: Pod
    metadata:
    name: webapp
    spec:
    containers:
    - name: event-simulator
        image: kodekloud/event-simulator
        env:
        - name: LOG_HANDLERS
        value: file
        volumeMounts:
        - mountPath: /log
        name: log-volume

    volumes:
    - name: log-volume
        persistentVolumeClaim:
        claimName: claim-log-1
    ```
    Then run the command `kubectl create -f <file-name>.yaml` to create a pod from the definition file.

13. What is the Reclaim Policy set on the Persistent Volume pv-log?

    Run the command: `kubectl get pv` and look under the `Reclaim Policy` column.

14. What would happen to the PV if the PVC was destroyed?

    The PV is not deleted but not available

15. Try deleting the PVC and notice what happens. If the command hangs, you can use CTRL + C to get back to the bash prompt OR check the status of the pvc from another terminal

    Run the command: kubectl delete pvc claim-log-1 and kubectl get pvc. If the command hangs, you can use CTRL + C to get back to the bash prompt OR check the status of the pvc from another terminal.
    ```
    root@controlplane:~# kubectl delete pvc claim-log-1 
    persistentvolumeclaim "claim-log-1" deleted


    ^C
    root@controlplane:~# kubectl get pvc
    NAME          STATUS        VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    claim-log-1   Terminating   pv-log   100Mi      RWX                           5m47s
    root@controlplane:~# 
    ```

16. Why is the PVC stuck in Terminating state?

    The PVC was still being used by the webapp pod when we issued the delete command. Until the pod is deleted, the PVC will remain in a terminating state.

17. Let us now delete the webapp Pod. Once deleted, wait for the pod to fully terminate.

    `k delete po webapp`

18. What is the state of the PVC now?

    `k get pvc`

19. What is the state of the Persistent Volume now?

    `k get pv`