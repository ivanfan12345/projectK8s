1. How many Secrets exist on the system?

    `k get secrets`

2. How many secrets are defined in the dashboard-token secret?

    ```
    controlplane ~ ➜  k describe secrets dashboard-token 
    Name:         dashboard-token
    Namespace:    default
    Labels:       <none>
    Annotations:  kubernetes.io/service-account.name: dashboard-sa
                kubernetes.io/service-account.uid: fdbfc683-aad5-4b07-b7a2-2104321f3d44

    Type:  kubernetes.io/service-account-token

    Data
    ====
    ca.crt:     570 bytes
    namespace:  7 bytes
    token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IlQzYlJCMWlmYzhEQVdKSVFHT0l5bVREX3ppeUUyd0l0ZFMzeE44aWxZYmsifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRhc2hib2FyZC10b2tlbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkYXNoYm9hcmQtc2EiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiJmZGJmYzY4My1hYWQ1LTRiMDctYjdhMi0yMTA0MzIxZjNkNDQiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpkYXNoYm9hcmQtc2EifQ.YfaYm_QsQumej81XrwLtGU1BQ2KpzTSGR3OMJMGjvk6h2i8OVAUM9uu4Y8w38PWDYs-FRTEZT6qga84xelt1A3-JkAhupj58iatbUfG4nCU_U_fq1drcQmjXJdlpati_gxr49SUgtoyeu_Q0M-0PeBqgxvcaSoiFYPFjqkwUBXsnNElKBZMxPhDlISh6FyWWepJGLNyUIzFn8-zLo7trxBhfAEUGo8wQ9l9Xug-XOZvIXq_-8Z0L1ODMAcwFlt_lEaEbgJsU-6DW2GErR-Aoff49kCk762ikhHhEPNVXZthHefmVuxJsyaYntBOQ4AzVF2AcI4-aIX8gzoEXTeK7DQ
    ```

3. What is the type of the dashboard-token secret?

    `k describe secrets dashboard-token | grep Type`

4. Which of the following is not a secret data defined in dashboard-token secret?

    `kubectl describe secrets dashboard-token`

6. The reason the application is failed is because we have not created the secrets yet. Create a new secret named db-secret with the data given below.

    You may follow any one of the methods discussed in lecture to create the secret.

    Secret Name: db-secret
    Secret 1: DB_Host=sql01
    Secret 2: DB_User=root
    Secret 3: DB_Password=password123

    `kubectl create secret generic db-secret --from-literal=DB_Host=sql01 --from-literal=DB_User=root --from-literal=DB_Password=password123`

7. Configure webapp-pod to load environment variables from the newly created secret.

    Pod name: webapp-pod
    Image name: kodekloud/simple-webapp-mysql
    Env From: Secret=db-secret

    ```
    ---
    apiVersion: v1 
    kind: Pod 
    metadata:
    labels:
        name: webapp-pod
    name: webapp-pod
    namespace: default 
    spec:
    containers:
    - image: kodekloud/simple-webapp-mysql
        imagePullPolicy: Always
        name: webapp
        envFrom:
        - secretRef:
            name: db-secret
    ```