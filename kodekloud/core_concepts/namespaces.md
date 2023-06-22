1. How many Namespaces exist on the system?

    `kubectl get ns --no-headers | wc -l`

2. How many pods exist in the research namespace?

    `kubectl -n research get pods --no-headers | wc -l`

3. Create a POD in the finance namespace.

    `k run redis --image=redis -n finance`

4. Which namespace has the blue pod in it?

    `k get po -A | grep blue`

5. Access the Blue web application using the link above your terminal!!

6. What DNS name should the Blue application use to access the database db-service in its own namespace - marketing?

    Since the blue application and the db-service are in the same namespace, we can simply use the service name to access the database.

7. What DNS name should the Blue application use to access the database db-service in the dev namespace?

    Since the blue application and the db-service are in different namespaces. In this case, we need to use the service name along with the namespace to access the database. The FQDN (fully Qualified Domain Name) for the db-service in this example would be db-service.dev.svc.cluster.local.

    Note: You can also access it using the service name and namespace like this: db-service.dev

