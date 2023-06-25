1. Identify the DNS solution implemented in this cluster.

    `kubectl get pods -n kube-system`

2. How many pods of the DNS server are deployed?

    `kubectl get pods -n kube-system`

3. What is the name of the service created for accessing CoreDNS?

    ```
    controlplane ~ ➜  k get svc -n kube-system 
    NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
    kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   7m1s
    ```

4. What is the IP of the CoreDNS server that should be configured on PODs to resolve services?

    Run the command: `kubectl get service -n kube-system` and look for cluster IP value. `10.96.0.10`

5. Where is the configuration file located for configuring the CoreDNS service?

    `k describe deploy -n kube-system coredns | grep Core`

6. How is the Corefile passed into the CoreDNS POD?

    Use the` kubectl get configmap` command for `kube-system` namespace and inspect the correct ConfigMap.

7. What is the name of the ConfigMap object created for Corefile?

    `kubectl get configmap -n kube-system`

8. What is the root domain/zone configured for this kubernetes cluster?

    Run the command:` kubectl describe configmap coredns -n kube-system` and look for the entry after kubernetes.

    ```
    controlplane ~ ➜   kubectl describe configmap coredns -n kube-system
    Name:         coredns
    Namespace:    kube-system
    Labels:       <none>
    Annotations:  <none>

    Data
    ====
    Corefile:
    ----
    .:53 {
        errors
        health {
        lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
        pods insecure
        fallthrough in-addr.arpa ip6.arpa
        ttl 30
        }
        prometheus :9153
        forward . /etc/resolv.conf {
        max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }

    BinaryData
    ====

    Events:  <none>
    ```

9. We have deployed a set of PODs and Services in the default and payroll namespaces. Inspect them and go to the next question.
    

10. What name can be used to access the hr web server from the test Application? You can execute a curl command on the test pod to test. Alternatively, the test Application also has a UI. Access it using the tab at the top of your terminal named test-app.

14. We just deployed a web server - webapp - that accesses a database mysql - server. However the web server is failing to connect to the database server. Troubleshoot and fix the issue. They could be in different namespaces. First locate the applications. The web server interface can be seen by clicking the tab Web Server at the top of your terminal.
    
    Web Server: webapp
    Uses the right DB_Host name

15. From the hr pod nslookup the mysql service and redirect the output to a file /root/CKA/nslookup.out

    Run the command: `kubectl exec -it hr -- nslookup mysql.payroll > /root/CKA/nslookup.out`

