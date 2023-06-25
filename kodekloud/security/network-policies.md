1. How many network policies do you see in the environment?

    `k get netpol`

2. What is the name of the Network Policy?

    `k get netpol`

3. Which pod is the Network Policy applied on?

    ``` 
    k describe netpol payroll-policy

    Name:         payroll-policy
    Namespace:    default
    Created on:   2023-06-24 22:41:48 -0400 EDT
    Labels:       <none>
    Annotations:  <none>
    Spec:
    PodSelector:     name=payroll
    Allowing ingress traffic:
        To Port: 8080/TCP
        From:
        PodSelector: name=internal
    Not affecting egress traffic
    Policy Types: Ingress
    ```


4. What type of traffic is this Network Policy configured to handle?

    `k describe netpol payroll-policy` and look under the Policy Types section.

5. What is the impact of the rule configured on this Network Policy?

    

6.

    

7.

    

8. Perform a connectivity test using the User Interface in these Applications to access the payroll-service at port 8080.



    

9. Perform a connectivity test using the User Interface of the Internal Application to access the external-service at port 8080.

    

10. Create a network policy to allow traffic from the Internal application only to the payroll-service and db-service. Use the spec given below. You might want to enable ingress traffic to the pod to test your rules in the UI.

    Policy Name: internal-policy
    Policy Type: Egress
    Egress Allow: payroll
    Payroll Port: 8080
    Egress Allow: mysql
    MySQL Port: 3306

    Solution manifest file for a network policy internal-policy as follows:
    ```
    apiVersion: networking.k8s.io/v1
    kind: NetworkPolicy
    metadata:
    name: internal-policy
    namespace: default
    spec:
    podSelector:
        matchLabels:
        name: internal
    policyTypes:
    - Egress
    - Ingress
    ingress:
        - {}
    egress:
    - to:
        - podSelector:
            matchLabels:
            name: mysql
        ports:
        - protocol: TCP
        port: 3306

    - to:
        - podSelector:
            matchLabels:
            name: payroll
        ports:
        - protocol: TCP
        port: 8080

    - ports:
        - port: 53
        protocol: UDP
        - port: 53
        protocol: TCP
    ```


    Note: We have also allowed Egress traffic to TCP and UDP port. This has been added to ensure that the internal DNS resolution works from the internal pod.



    Remember: The kube-dns service is exposed on port 53:
    ```

    root@controlplane:~> kubectl get svc -n kube-system 
    NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
    kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   18m

    root@controlplane:~>
    ```
