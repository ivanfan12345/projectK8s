1. Create a new pod called web-pod with image busybox Allow the pod to be able to set system_time​. The container should sleep for 3200 seconds​

2. Create a new deployment called myproject, with image nginx:1.16 and ​1 replica. Next upgrade the deployment to version 1.17 using rolling​ update​. Make sure that the version upgrade is recorded in the resource annotation.​

3. Create a new deployment called my-deployment. Scale the deployment to 3 replicas.             ​
Make sure desired number of pod always running. 

4. Deploy a web-nginx pod using the nginx:1.17 image with the labels set to tier=web-app.​

5. Create a static pod on node01 called static-pod with image nginx and you     have to make sure that it is recreated/restarted automatically in case ​of any failure happens

6. Create a pod called pod-multi with two containers, as given below:​
Container 1 - name: container1, image: nginx​
Container2 - name: container2, image: busybox, command: sleep 4800​

7. Create a pod called test-pod in "custom" namespace belonging to the test environment (env=test) and backend tier (tier=backend).​ image: nginx:1.17​

8. Get the node node01 in JSON format and store it in a file at ​ ./node-info.json​

9. Use JSON PATH query to retrieve the oslmages of all the nodes and store it in a file “all-nodes-os-info.txt” at root location.​ 
Note: The osImage are under the nodeInfo section under status of each node.
​
10. Create a Persistent Volume with the given specification.​
       Volume Name: pv-demo​
             Storage:100Mi​
Access modes: ReadWriteMany​
  Host Path: /pv/host-data​

11. Worker Node “node01” not responding, Debug the issue and fix it.​

12. Upgrade the Cluster (Master and worker Node) from 1.18.0 to 1.19.0. Make sure to first drain both Node and make it available after upgrade.​

13. Take a backup of the ETCD database and save it to “/opt/etcd-backup.db” . Also restore the ETCD database from the backup​.




