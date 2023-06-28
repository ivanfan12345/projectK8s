1. Where is the default kubeconfig file located in the current environment? Find the current home directory by looking at the HOME environment variable.

    `/root/.kube/config`

2. How many clusters are defined in the default kubeconfig file?

    `kubectl config view`

3. How many Users are defined in the default kubeconfig file?

    `kubectl config view`

4. How many contexts are defined in the default kubeconfig file?

    `kubectl config view`

5. What is the user configured in the current context?

    `kubectl config view`

6. What is the name of the cluster configured in the default kubeconfig file?

    `kubectl config view`

7. A new kubeconfig file named my-kube-config is created. It is placed in the /root directory. How many clusters are defined in that kubeconfig file?

    `cat my-kube-config`

8. How many contexts are configured in the my-kube-config file?

    `cat my-kube-config`

9. What user is configured in the research context?

    `cat my-kube-config`

10. What is the name of the client-certificate file configured for the aws-user?

    `cat my-kube-config`

11. What is the current context set to in the my-kube-config file?

    `kubectl config current-context --kubeconfig my-kube-config`

12. I would like to use the dev-user to access test-cluster-1. Set the current context to the right one so I can do that. Once the right context is identified, use the kubectl config use-context command.

    To use that context, run the command: `kubectl config --kubeconfig=/root/my-kube-config use-context research`

    To know the current context, run the command: `kubectl config --kubeconfig=/root/my-kube-config current-context`

13. We don't want to have to specify the kubeconfig file option on each command. Make the my-kube-config file the default kubeconfig.

    Replace the contents in the default kubeconfig file with the content from my-kube-config file.
    `mv my-kube-config ~/.kube/config `

14. With the current-context set to research, we are trying to access the cluster. However something seems to be wrong. Identify and fix the issue.

    Try running the kubectl get pods command and look for the error. All users certificates are stored at /etc/kubernetes/pki/users.

    The path to certificate is incorrect in the kubeconfig file. Correct the certificate name which is available at /etc/kubernetes/pki/users/.
    ```
    k get cluster-info
    error: unable to read client-cert /etc/kubernetes/pki/users/dev-user/developer-user.crt for dev-user due to open /etc/kubernetes/pki/users/dev-user/developer-user.crt: no such file or directory
    ```