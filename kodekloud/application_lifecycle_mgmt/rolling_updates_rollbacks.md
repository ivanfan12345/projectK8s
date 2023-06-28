1. We have deployed a simple web application. Inspect the PODs and the Services

    `k get po`

2. What is the current color of the web application?

    `blue`

3. Run the script named curl-test.sh to send multiple requests to test the web application. Take a note of the output.

4. Inspect the deployment and identify the number of PODs deployed by it

    `k desribe deploy` look at desired replicas.

5. What container image is used to deploy the applications?

    `kubectl describe deployment | grep Image`

6. Inspect the deployment and identify the current strategy

    `kubectl describe deployment | grep StrategyType`

7. If you were to upgrade the application now what would happen?

    `PODs are upgraded few at a time`

8. Let us try that. Upgrade the application by setting the image on the deployment to kodekloud/webapp-color:v2

    `Run the command `kubectl edit deployment frontend` and modify the required feild.`

9. Run the script curl-test.sh again. Notice the requests now hit both the old and newer versions. However none of them fail.

10.  Up to how many PODs can be down for upgrade at a time

    `Look at the Max Unavailable value under RollingUpdateStrategy in deployment details.`

11. Change the deployment strategy to Recreate

    `Run the command `kubectl edit deployment frontend` and modify the required field. Make sure to delete the properties of rollingUpdate as well, set at `strategy.rollingUpdate`.`

12.  Change the deployment strategy to Recreate
    Delete and re-create the deployment if necessary. Only update the strategy type for the existing deployment.

    ```
    ---
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: frontend
    namespace: default
    spec:
    replicas: 4
    selector:
        matchLabels:
        name: webapp
    strategy:
        type: Recreate
    template:
        metadata:
        labels:
            name: webapp
        spec:
        containers:
        - image: kodekloud/webapp-color:v2
            name: simple-webapp
            ports:
            - containerPort: 8080
            protocol: TCP
    ```

13. Upgrade the application by setting the image on the deployment to` kodekloud/webapp-color:v3`.

    `kubectl edit deployment frontend`