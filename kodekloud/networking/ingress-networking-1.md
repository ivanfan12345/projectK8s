1. We have deployed Ingress Controller, resources and applications. Explore the setup.

    Use the command kubectl get all -A and identify the namespace of Ingress Controller.

2. Which namespace is the Ingress Controller deployed in?

    Use the command kubectl get all -A and identify the namespace of Ingress Controller.

3. What is the name of the Ingress Controller Deployment?

    `k get deploy -A`

4. Which namespace are the applications deployed in?

    `k get po -A`

5. How many applications are deployed in the app-space namespace?

    `kubectl get deploy --namespace app-space`

6. Which namespace is the Ingress Resource deployed in?

    `k get ingress -A`

7. What is the name of the Ingress Resource?

    `k get ingress -A`

8. What is the Host configured on the Ingress Resource? The host entry defines the domain name that users use to reach the application like www.google.com

    ```
    k describe ingress -n app-space ingress-wear-watch 
    Name:             ingress-wear-watch
    Labels:           <none>
    Namespace:        app-space
    Address:          10.111.110.35
    Ingress Class:    <none>
    Default backend:  <default>
    Rules:
    Host        Path  Backends
    ----        ----  --------
    *           
                /wear    wear-service:8080 (10.244.0.4:8080)
                /watch   video-service:8080 (10.244.0.5:8080)
    Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /
                nginx.ingress.kubernetes.io/ssl-redirect: false
    Events:
    Type    Reason  Age                    From                      Message
    ----    ------  ----                   ----                      -------
    Normal  Sync    5m53s (x2 over 5m54s)  nginx-ingress-controller  Scheduled for sync
  ```

9. What backend is the /wear path on the Ingress configured with?

    `k describe ingress -n app-space ingress-wear-watch`

10. At what path is the video streaming application made available on the Ingress?

    `k describe ingress -n app-space ingress-wear-watch`

11. If the requirement does not match any of the configured paths what service are the requests forwarded to?

    Run the command: `kubectl describe ingress --namespace app-space` and look at the Default backend field.

12. Now view the Ingress Service using the tab at the top of the terminal. Which page do you see? Click on the tab named Ingress.

13. View the applications by appending /wear and /watch to the URL you opened in the previous step.

14. You are requested to change the URLs at which the applications are made available. Make the video application available at /stream.

    Ingress: ingress-wear-watch
    Path: /stream
    Backend Service: video-service
    Backend Service Port: 8080

    Run the command: kubectl edit ingress --namespace app-space and change the path to the video streaming application to /stream.

    Solution manifest file to change the path to the video streaming application to /stream as follows:
    ```
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
    name: ingress-wear-watch
    namespace: app-space
    spec:
    rules:
    - http:
        paths:
        - backend:
            service:
                name: wear-service
                port: 
                number: 8080
            path: /wear
            pathType: Prefix
        - backend:
            service:
                name: video-service
                port: 
                number: 8080
            path: /stream
            pathType: Prefix
    ```

15. View the Video application using the /stream URL in your browser.

16. A user is trying to view the /eat URL on the Ingress Service. Which page would he see?

18. Due to increased demand, your business decides to take on a new venture. You acquired a food delivery company. Their applications have been migrated over to your cluster.

    Ingress: ingress-wear-watch
    Path: /eat
    Backend Service: food-service
    Backend Service Port: 8080

    ```
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
    name: ingress-wear-watch
    namespace: app-space
    spec:
    rules:
    - http:
        paths:
        - backend:
            service:
                name: wear-service
                port: 
                number: 8080
            path: /wear
            pathType: Prefix
        - backend:
            service:
                name: video-service
                port: 
                number: 8080
            path: /stream
            pathType: Prefix
        - backend:
            service:
                name: food-service
                port: 
                number: 8080
            path: /eat
            pathType: Prefix
    ```

20. A new payment service has been introduced. Since it is critical, the new application is deployed in its own namespace. Identify the namespace in which the new application is deployed.

    `kubectl get deploy --all-namespaces`

21. What is the name of the deployment of the new application?

    `kubectl get deploy --all-namespaces`

22. You are requested to make the new application available at /pay. Identify and implement the best approach to making this application available on the ingress controller and test to make sure its working. Look into annotations: rewrite-target as well.

    Ingress Created
    Path: /pay
    Configure correct backend service
    Configure correct backend port

    Create a new Ingress for the new pay application in the critical-space namespace. Use the command kubectl get svc -n critical-space to know the service and port details.

    Solution manifest file to create a new ingress service to make the application available at /pay as follows:
    ```
    ---
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    name: test-ingress
    namespace: critical-space
    annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
    spec:
    rules:
    - http:
        paths:
        - path: /pay
            pathType: Prefix
            backend:
            service:
            name: pay-service
            port:
                number: 8282
    ```

23. View the Payment application using the /pay URL in your browser.

