1. How many Services exist on the system?

    `k get svc`

2. What is the type of the default kubernetes service?

    Run the command: `kubectl get service` and look at the Type column.

3. What is the targetPort configured on the kubernetes service?

    `k get svc` look for `TargetPort`

4. How many labels are configured on the kubernetes service?

    `k get svc` look at `Labels`

5. How many Endpoints are attached on the kubernetes service?

    Run the command: `kubectl describe service` and look at the Endpoints.

6. How many Deployments exist on the system now?

    `k get deploy`

8. What is the image used to create the pods in the deployment?

    Run the command: `kubectl describe deployment` and look under the `containers` section.

9. Are you able to accesss the Web App UI?

10. Create a new service to access the web application using the service-definition-1.yaml file.

    Name: webapp-service
    Type: NodePort
    targetPort: 8080
    port: 8080
    nodePort: 30080
    selector:
    name: simple-webapp

```
---
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
  namespace: default
spec:
  ports:
  - nodePort: 30080
    port: 8080
    targetPort: 8080
  selector:
    name: simple-webapp
  type: NodePort
```

11. Access the web application using the tab simple-webapp-ui above the terminal window.

