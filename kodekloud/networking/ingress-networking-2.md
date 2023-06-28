1. We have deployed two applications. Explore the setup.

    `k get all -A`

2. Let us now deploy an Ingress Controller. First, create a namespace called ingress-nginx. We will isolate all ingress related objects into its own namespace.

    `kubectl create namespace ingress-nginx`

3. The NGINX Ingress Controller requires a ConfigMap object. Create a ConfigMap object with name ingress-nginx-controller in the ingress-nginx namespace.

    `kubectl create configmap ingress-nginx-controller --namespace ingress-nginx`

4. The NGINX Ingress Controller requires two ServiceAccounts. Create both ServiceAccount with name ingress-nginx and ingress-nginx-admission in the ingress-nginx namespace.
    
    Name: ingress-nginx
    Name: ingress-nginx-admission

    `kubectl create serviceaccount ingress-nginx --namespace ingress-nginx`
    `kubectl create serviceaccount ingress-nginx-admission --namespace ingress-nginx`

5. We have created the Roles, RoleBindings, ClusterRoles, and ClusterRoleBindings for the ServiceAccount. Check it out!!
    

6. Let us now deploy the Ingress Controller. Create the Kubernetes objects using the given file. The Deployment and it's service configuration is given at /root/ingress-controller.yaml. There are several issues with it. Try to fix them.

    Deployed in the correct namespace.
    Replicas: 1
    Use the right image
    Namespace: ingress-nginx
    Service name: ingress-nginx-controller
    NodePort: 30080

    We need to look at the Deployment's namespace, containerPort, and Service's name, nodePort.
    Solution manifest file to create a ingress-controller.yaml as follows: -
    ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/name: ingress-nginx
        app.kubernetes.io/part-of: ingress-nginx
        app.kubernetes.io/version: 1.1.2
        helm.sh/chart: ingress-nginx-4.0.18
    name: ingress-nginx-controller
    namespace: ingress-nginx
    spec:
    minReadySeconds: 0
    revisionHistoryLimit: 10
    selector:
        matchLabels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
    template:
        metadata:
        labels:
            app.kubernetes.io/component: controller
            app.kubernetes.io/instance: ingress-nginx
            app.kubernetes.io/name: ingress-nginx
        spec:
        containers:
        - args:
            - /nginx-ingress-controller
            - --publish-service=$(POD_NAMESPACE)/ingress-nginx-controller
            - --election-id=ingress-controller-leader
            - --watch-ingress-without-class=true
            - --default-backend-service=app-space/default-http-backend
            - --controller-class=k8s.io/ingress-nginx
            - --ingress-class=nginx
            - --configmap=$(POD_NAMESPACE)/ingress-nginx-controller
            - --validating-webhook=:8443
            - --validating-webhook-certificate=/usr/local/certificates/cert
            - --validating-webhook-key=/usr/local/certificates/key
            env:
            - name: POD_NAME
            valueFrom:
                fieldRef:
                fieldPath: metadata.name
            - name: POD_NAMESPACE
            valueFrom:
                fieldRef:
                fieldPath: metadata.namespace
            - name: LD_PRELOAD
            value: /usr/local/lib/libmimalloc.so
            image: registry.k8s.io/ingress-nginx/controller:v1.1.2@sha256:28b11ce69e57843de44e3db6413e98d09de0f6688e33d4bd384002a44f78405c
            imagePullPolicy: IfNotPresent
            lifecycle:
            preStop:
                exec:
                command:
                - /wait-shutdown
            livenessProbe:
            failureThreshold: 5
            httpGet:
                path: /healthz
                port: 10254
                scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 1
            name: controller
            ports:
            - name: http
            containerPort: 80
            protocol: TCP
            - containerPort: 443
            name: https
            protocol: TCP
            - containerPort: 8443
            name: webhook
            protocol: TCP
            readinessProbe:
            failureThreshold: 3
            httpGet:
                path: /healthz
                port: 10254
                scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 1
            resources:
            requests:
                cpu: 100m
                memory: 90Mi
            securityContext:
            allowPrivilegeEscalation: true
            capabilities:
                add:
                - NET_BIND_SERVICE
                drop:
                - ALL
            runAsUser: 101
            volumeMounts:
            - mountPath: /usr/local/certificates/
            name: webhook-cert
            readOnly: true
        dnsPolicy: ClusterFirst
        nodeSelector:
            kubernetes.io/os: linux
        serviceAccountName: ingress-nginx
        terminationGracePeriodSeconds: 300
        volumes:
        - name: webhook-cert
            secret:
            secretName: ingress-nginx-admission

    ---

    apiVersion: v1
    kind: Service
    metadata:
    creationTimestamp: null
    labels:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/name: ingress-nginx
        app.kubernetes.io/part-of: ingress-nginx
        app.kubernetes.io/version: 1.1.2
        helm.sh/chart: ingress-nginx-4.0.18
    name: ingress-nginx-controller
    namespace: ingress-nginx
    spec:
    ports:
    - port: 80
        protocol: TCP
        targetPort: 80
        nodePort: 30080
    selector:
        app.kubernetes.io/component: controller
        app.kubernetes.io/instance: ingress-nginx
        app.kubernetes.io/name: ingress-nginx
    type: NodePort
    ```

7. Create the ingress resource to make the applications available at /wear and /watch on the Ingress service.

    Also, make use of rewrite-target annotation field:
    ```
    nginx.ingress.kubernetes.io/rewrite-target: /
    ```

    Ingress resource comes under the namespace scoped, so don't forget to create the ingress in the app-space namespace.

    Ingress Created
    Path: /wear
    Path: /watch
    Configure correct backend service for /wear
    Configure correct backend service for /watch
    Configure correct backend port for /wear service
    Configure correct backend port for /watch service

    Solution manifest file to create a ingress resource as follows:
    ```
    ---
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    name: ingress-wear-watch
    namespace: app-space
    annotations:
        nginx.ingress.kubernetes.io/rewrite-target: /
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
    spec:
    rules:
    - http:
        paths:
        - path: /wear
            pathType: Prefix
            backend:
            service:
            name: wear-service
            port: 
                number: 8080
        - path: /watch
            pathType: Prefix
            backend:
            service:
            name: video-service
            port:
                number: 8080
    ```