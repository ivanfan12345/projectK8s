1. A new member akshay joined our team. He requires access to our cluster. The Certificate Signing Request is at the /root location.

    `cat balh.csr`

2. Create a CertificateSigningRequest object with the name akshay with the contents of the akshay.csr file. 

As of kubernetes 1.19, the API to use for CSR is certificates.k8s.io/v1. Please note that an additional field called signerName should also be added when creating CSR. For client authentication to the API server we will use the built-in signer kubernetes.io/kube-apiserver-client.

    Use this command to generate the base64 encoded format as following:

    `cat akshay.csr | base64 -w 0`

    Finally, save the below YAML in a file and create a CSR name akshay as follows: -
    ```
    ---
    apiVersion: certificates.k8s.io/v1
    kind: CertificateSigningRequest
    metadata:
    name: akshay
    spec:
    groups:
    - system:authenticated
    request: <Paste the base64 encoded value of the CSR file>
    signerName: kubernetes.io/kube-apiserver-client
    usages:
    - client auth
    ```

    `kubectl apply -f akshay-csr.yaml`

3. What is the Condition of the newly created Certificate Signing Request object?

    `kubectl get csr`

4. Approve the CSR Request.

    `kubectl certificate approve akshay`

5. How many CSR requests are available on the cluster?

    `kubectl get csr`

6. During a routine check you realized that there is a new CSR request in place. What is the name of this request?

    `k get csr`

7. Hmmm.. You are not aware of a request coming in. What groups is this CSR requesting access to?

    `kubectl get csr agent-smith -o yaml`

8. That doesn't look very right. Reject that request.

    `kubectl certificate deny agent-smith`

9. Let's get rid of it. Delete the new CSR object

    `k delete csr agent-smith`

10.

