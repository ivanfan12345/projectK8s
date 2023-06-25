1. For the first few questions of this lab, you would have to inspect the existing ClusterRoles and ClusterRoleBindings that have been created in this cluster.

2. How many ClusterRoles do you see defined in the cluster?

    `k get clusterroles --no-headers | wc -l`

3. How many ClusterRoleBindings exist on the cluster?

    `k get clusterrolebindings --no-headers  | wc -l`

4. What namespace is the cluster-admin clusterrole part of?

    ClusterRole is a non-namespaced resource. You can check via the kubectl api-resources --namespaced=false command. So the correct answer would be Cluster Roles are cluster wide and not part of any namespace.

5. What user/groups are the cluster-admin role bound to? The ClusterRoleBinding for the role is with the same name.

    `kubectl describe clusterrolebinding cluster-admin`

6. What level of permission does the cluster-admin role grant? Inspect the cluster-admin role's privileges.

    ```
    k describe clusterrole cluster-admin -n kube-system
    Name:         cluster-admin
    Labels:       kubernetes.io/bootstrapping=rbac-defaults
    Annotations:  rbac.authorization.kubernetes.io/autoupdate: true
    PolicyRule:
    Resources  Non-Resource URLs  Resource Names  Verbs
    ---------  -----------------  --------------  -----
    *.*        []                 []              [*]
                [*]                []              [*]
    ```

7. A new user michelle joined the team. She will be focusing on the nodes in the cluster. Create the required ClusterRoles and ClusterRoleBindings so she gets access to the nodes.

    Use the command `kubectl create` to create a clusterrole and clusterrolebinding for user `michelle` to grant access to the nodes.
    After that test the access using the command `kubectl auth can-i list nodes --as michelle`.


    Solution manifest file to create a clusterrole and clusterrolebinding for michelle user:
    ```
    ---
    kind: ClusterRole
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: node-admin
    rules:
    - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "watch", "list", "create", "delete"]

    ---
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: michelle-binding
    subjects:
    - kind: User
    name: michelle
    apiGroup: rbac.authorization.k8s.io
    roleRef:
    kind: ClusterRole
    name: node-admin
    apiGroup: rbac.authorization.k8s.io
    ```
After save into a file, run the command kubectl create -f <file-name>.yaml to create a resources from definition file.

8. michelle's responsibilities are growing and now she will be responsible for storage as well. Create the required ClusterRoles and ClusterRoleBindings to allow her access to Storage. Get the API groups and resource names from command kubectl api-resources. Use the given spec:

    ClusterRole: storage-admin
    Resource: persistentvolumes
    Resource: storageclasses
    ClusterRoleBinding: michelle-storage-admin
    ClusterRoleBinding Subject: michelle
    ClusterRoleBinding Role: storage-admin
    
    Use the command kubectl create to create a new ClusterRole and ClusterRoleBinding. Assign it correct resources and verbs. After that test the access using the command `kubectl auth can-i list storageclasses --as michelle`.

    Solution manifest file to create a clusterrole and clusterrolebinding for michelle user:
    ```
    ---
    kind: ClusterRole
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: storage-admin
    rules:
    - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "watch", "list", "create", "delete"]
    - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "watch", "list", "create", "delete"]

    ---
    kind: ClusterRoleBinding
    apiVersion: rbac.authorization.k8s.io/v1
    metadata:
    name: michelle-storage-admin
    subjects:
    - kind: User
    name: michelle
    apiGroup: rbac.authorization.k8s.io
    roleRef:
    kind: ClusterRole
    name: storage-admin
    apiGroup: rbac.authorization.k8s.io
    ```
    After save into a file, run the command kubectl create -f <file-name>.yaml to create a resources from definition file.

