

1. Identify the certificate file used for the kube-api server.

    Run the command `cat /etc/kubernetes/manifests/kube-apiserver.yaml` and look for the line --tls-cert-file.

2. Identify the Certificate file used to authenticate kube-apiserver as a client to ETCD Server.

    `cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep etcd-cert`

3. Identify the key used to authenticate kubeapi-server to the kubelet server.

    `cat /etc/kubernetes/manifests/kube-apiserver.yaml | grep kubelet-client-key`

4. Identify the ETCD Server Certificate used to host ETCD server.

    `cat /etc/kubernetes/manifests/etcd.yaml  | grep cert-file`

5. Identify the ETCD Server CA Root Certificate used to serve ETCD Server. ETCD can have its own CA. So this may be a different CA certificate than the one used by kube-api server.

    `cat /etc/kubernetes/manifests/etcd.yaml | grep trusted-ca-file`

6. What is the Common Name (CN) configured on the Kube API Server Certificate? OpenSSL Syntax: `openssl x509 -in file-path.crt -text -noout`

    Run the command `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text` and look for Subject CN.

7. What is the name of the CA who issued the Kube API Server Certificate?

    `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text`

8. Which of the below alternate names is not configured on the Kube API Server Certificate?

    Run the command `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text` and look at `Alternative Names`.

9. What is the Common Name (CN) configured on the ETCD Server certificate?

    `openssl x509 -in /etc/kubernetes/pki/etcd/server.crt -text -noout`

10. How long, from the issued date, is the Kube-API Server Certificate valid for? File: `/etc/kubernetes/pki/apiserver.crt`

    `openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text`

11. How long, from the issued date, is the Root CA Certificate valid for? `File: /etc/kubernetes/pki/ca.crt`

    `openssl x509 -in /etc/kubernetes/pki/ca.crt -text`

12. Kubectl suddenly stops responding to your commands. Check it out! Someone recently modified the /etc/kubernetes/manifests/etcd.yaml file You are asked to investigate and fix the issue. Once you fix the issue wait for sometime for kubectl to respond. Check the logs of the ETCD container.

    Inspect the --cert-file option in the manifests file.

13. The kube-api server stopped again! Check it out. Inspect the kube-api server logs and identify the root cause and fix the issue. Run crictl ps -a command to identify the kube-api server container. Run crictl logs container-id command to view the logs.

    If we inspect the kube-apiserver container on the controlplane, we can see that it is frequently exiting.
    ```
    root@controlplane:~# crictl ps -a | grep kube-apiserver
    1fb242055cff8       529072250ccc6       About a minute ago   Exited              kube-apiserver            3                   ed2174865a416       kube-apiserver-controlplane
    ```
    If we now inspect the logs of this exited container, we would see the following errors:
    ```

    root@controlplane:~# crictl logs --tail=2 1fb242055cff8  
    W0916 14:19:44.771920       1 clientconn.go:1331] [core] grpc: addrConn.createTransport failed to connect to {127.0.0.1:2379 127.0.0.1 <nil> 0 <nil>}. Err: connection error: desc = "transport: authentication handshake failed: x509: certificate signed by unknown authority". Reconnecting...
    E0916 14:19:48.689303       1 run.go:74] "command failed" err="context deadline exceeded"
    ```
    This indicates an issue with the ETCD CA certificate used by the kube-apiserver. Correct it to use the file /etc/kubernetes/pki/etcd/ca.crt.

    Once the YAML file has been saved, wait for the kube-apiserver pod to be Ready. This can take a couple of minutes.