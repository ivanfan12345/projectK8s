1. We have deployed a few PODs running workloads. Inspect them.

2. Let us deploy metrics-server to monitor the PODs and Nodes. Pull the git repository for the deployment files.

    `Run: git clone https://github.com/kodekloudhub/kubernetes-metrics-server.git`

3. Deploy the metrics-server by creating all the components downloaded.

    `Run the kubectl create -f . command from within the downloaded repository.`

4. It takes a few minutes for the metrics server to start gathering data.

    `kubectl top node`

5. It takes a few minutes for the metrics server to start gathering data.

    `k top node`

6. Identify the node that consumes the most Memory(bytes).

    `kubectl top node --sort-by='memory'  --no-headers | head -1`

7. Identify the POD that consumes the most Memory(bytes).

    `kubectl top pod --sort-by='memory'  --no-headers | head -1`

8. Identify the POD that consumes the least CPU(cores).

    `kubectl top pod --sort-by='cpu' --no-headers | tail -1`