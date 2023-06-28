1. How many Service Accounts exist in the default namespace?

    `k get sa`

2. What is the secret token used by the default service account?

    `k describe sa default`

3. We just deployed the Dashboard application. Inspect the deployment. What is the image used by the deployment?

    `kubectl describe deployment`

5. What is the state of the dashboard? Have the pod details loaded successfully?

6. What type of account does the Dashboard application use to query the Kubernetes API?

    `pods is forbidden: User "system:serviceaccount:default:default" cannot list resource "pods" in API group "" in the namespace "default"`

7. Which account does the Dashboard application use to query the Kubernetes API?

    `pods is forbidden: User "system:serviceaccount:default:default" cannot list resource "pods" in API group "" in the namespace "default"`

8. Inspect the Dashboard Application POD and identify the Service Account mounted on it.

    `k describe po web-dashboard-97c9c59f6-njl2c`

9. At what location is the ServiceAccount credentials available within the pod?

    `Mounts: /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-4cbtv (ro)`

10. The application needs a ServiceAccount with the Right permissions to be created to authenticate to Kubernetes. The default ServiceAccount has limited access. Create a new ServiceAccount named dashboard-sa.

    `k create sa dashboard-sa`

11. We just added additional permissions for the newly created dashboard-sa account using RBAC.

12. Enter the access token in the UI of the dashboard application. Click Load Dashboard button to load Dashboard. Create an authorization token for the newly created service account, copy the generated token and paste it into the token field of the UI.

To do this, run `kubectl create token dashboard-sa` for the `dashboard-sa` service account, copy the token and paste it in the UI.

    ```
    kubectl create token dashboard-sa
    eyJhbGciOiJSUzI1NiIsImtpZCI6IjhVMkNOVllOYTNMRXdGU0pJNVQyVFpndWZCaHZSbThnMl9nSTdJbEIyTXMifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiLCJrM3MiXSwiZXhwIjoxNjg3NjYyNDcyLCJpYXQiOjE2ODc2NTg4NzIsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJkZWZhdWx0Iiwic2VydmljZWFjY291bnQiOnsibmFtZSI6ImRhc2hib2FyZC1zYSIsInVpZCI6ImRlMTdkYmMzLTc4NjEtNDlkMC1hNmIwLTJmNWI2MzY4NWE2NCJ9fSwibmJmIjoxNjg3NjU4ODcyLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpkYXNoYm9hcmQtc2EifQ.q7eJbiVP7R3Ey_ztGCnLq8mntYfT6I1bnOULgQqEdXpjOJt5LmBCNr2behajZl9cfrqw9qFrUPcsVKZlqX38lKvy-LhyfGlA65wf9l0iqV8MbSY9l9noxnXlqSf7FfLlf5gICiBhh7mmVVocEHYzwQ41SFDsh4fgjmogjqbN8b9ndc_NTt-6kA4VROn7cT6YyziZQcy-7yu_gtTnp31vSc8YLoA192T06yzT1PNSXkGdYYXIDjLAjk5yaNWcy5RTNFfa8NPfsAxrayzR51iSp1FCZV_Vjxmu-nBYLoTIqeaLh_HK5pTRw1xFhrveLYysVUUIEScpAz43kX2TwKuaYA
    ```

13. You shouldn't have to copy and paste the token each time. The Dashboard application is programmed to read token from the secret mount location. However currently, the default service account is mounted. Update the deployment to use the newly created ServiceAccount. Edit the deployment to change ServiceAccount from default to dashboard-sa.

    Use the `kubectl edit` command for the deployment and specify the serviceAccountName field inside the pod spec.

    OR

    Make use of the `kubectl set` command. Run the following command to use the newly created service account: - `kubectl set serviceaccount deploy/web-dashboard dashboard-sa`

    OR

    ```
    apiVersion: apps/v1
    kind: Deployment
    metadata:
    name: web-dashboard
    namespace: default
    spec:
    replicas: 1
    selector:
        matchLabels:
        name: web-dashboard
    strategy:
        rollingUpdate:
        maxSurge: 25%
        maxUnavailable: 25%
        type: RollingUpdate
    template:
        metadata:
        creationTimestamp: null
        labels:
            name: web-dashboard
        spec:
        serviceAccountName: dashboard-sa
        containers:
        - image: gcr.io/kodekloud/customimage/my-kubernetes-dashboard
            imagePullPolicy: Always
            name: web-dashboard
            ports:
            - containerPort: 8080
            protocol: TCP
    ```

14. Refresh the Dashboard application UI and you should now see the PODs listed automatically.