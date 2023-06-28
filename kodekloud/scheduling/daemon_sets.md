1. How many DaemonSets are created in the cluster in all namespaces?

    `k get ds -A`

2. Which namespace is the kube-proxy Daemonset created in?

    `kubectl get daemonsets --all-namespaces`

4. On how many nodes are the pods scheduled by the DaemonSet kube-proxy?

    `kubectl describe daemonset kube-proxy --namespace=kube-system`

5. What is the image used by the POD deployed by the kube-flannel-ds DaemonSet?


    `kubectl describe daemonset kube-flannel-ds --namespace=kube-flannel`

6. Deploy a DaemonSet for FluentD Logging.

    An easy way to create a DaemonSet is to first generate a YAML file for a Deployment with the command `kubectl create deployment elasticsearch --image=registry.k8s.io/fluentd-elasticsearch:1.20 -n kube-system --dry-run=client -o yaml > fluentd.yaml`. Next, remove the replicas, strategy and status fields from the YAML file using a text editor. Also, change the kind from `Deployment` to `DaemonSet`.

    Finally, create the Daemonset by running `kubectl create -f fluentd.yaml`