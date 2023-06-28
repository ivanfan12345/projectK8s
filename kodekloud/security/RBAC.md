1. Inspect the environment and identify the authorization modes configured on the cluster. Check the kube-apiserver settings.

    `kubectl describe pod kube-apiserver-controlplane -n kube-system | grep authorization-mode`

2. How many roles exist in the default namespace?

    `kubectl get roles`

3. How many roles exist in all namespaces together?

    `k get roles -A --no-headers | wc -l`

4. What are the resources the kube-proxy role in the kube-system namespace is given access to?

    `kubectl describe role kube-proxy -n kube-system`

5. What actions can the kube-proxy role perform on configmaps?

    `kubectl describe role kube-proxy -n kube-system`

6. Which of the following statements are true?

    `kubectl describe role kube-proxy -n kube-system`

7. Which account is the kube-proxy role assigned to?

    `kubectl describe rolebinding kube-proxy -n kube-system`

8. A user dev-user is created. User's details have been added to the kubeconfig file. Inspect the permissions granted to the user. Check if the user can list pods in the default namespace. Use the --as dev-user option with kubectl to run commands as the dev-user.

    `kubectl get pods --as dev-user`

9. Create the necessary roles and role bindings required for the dev-user to create, list and delete pods in the default namespace.

    Role: developer
    Role Resources: pods
    Role Actions: list
    Role Actions: create
    Role Actions: delete
    RoleBinding: dev-user-binding
    RoleBinding: Bound to dev-user


    To create a Role:- `kubectl create role developer --namespace=default --verb=list,create,delete --resource=pods`

    To create a RoleBinding:- `kubectl create rolebinding dev-user-binding --namespace=default --role=developer --user=dev-user`

    Solution manifest file to create a role and rolebinding in the default namespace:
    ```
    kind: Role
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    namespace: default
    name: developer
    rules:
    - apiGroups: [""]
    resources: ["pods"]
    verbs: ["list", "create","delete"]

    ---
    kind: RoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: dev-user-binding
    subjects:
    - kind: User
    name: dev-user
    apiGroup: rbac.authorization.k8s.io
    roleRef:
    kind: Role
    name: developer
    apiGroup: rbac.authorization.k8s.io
    ```

10. A set of new roles and role-bindings are created in the blue namespace for the dev-user. However, the dev-user is unable to get details of the dark-blue-app pod in the blue namespace. Investigate and fix the issue. We have created the required roles and rolebindings, but something seems to be wrong.

    New roles and role bindings are created in the blue namespace. Check out the resourceNames configured on the role.

    Run the command: `kubectl edit role developer -n blue` and correct the resourceNames field. You don't have to delete the role.

11. Add a new rule in the existing role developer to grant the dev-user permissions to create deployments in the blue namespace. Remember to add api group "apps".

    Edit the developer role in the blue namespace to add a new rule under the rules section.Append the below rule to the end of the file
    ```
    kubectl edit role developer -n blue
    - apiGroups:
    - apps
    resources:
    - deployments
    verbs:
    - create
    ```
    So it looks like this:
    ```
    apiVersion: rbac.authorization.k8s.io/v1
    kind: Role
    metadata:
    name: developer
    namespace: blue
    rules:
    - apiGroups:
    - apps
    resourceNames:
    - dark-blue-app
    resources:
    - pods
    verbs:
    - get
    - watch
    - create
    - delete
    - apiGroups:
    - apps
    resources:
    - deployments
    verbs:
    - create
    ```