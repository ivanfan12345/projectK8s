1. How many nodes exist on the system?

    `k get no`

2. Do any taints exist on node01 node?

    `kubectl describe node node01 | grep -i taints`

3. Create a taint on node01 with key of spray, value of mortein and effect of NoSchedule

    `kubectl taint nodes node01 spray=mortein:NoSchedule`

4. Create a new pod with the nginx image and pod name as mosquito.

    `k run mosquito --image=nginx`

5. What is the state of the POD?

    `k get po`

6. Why do you think the pod is in a pending state?

    0/2 nodes are available: 1 node(s) had untolerated taint {node-role.kubernetes.io/control-plane: }, 1 node(s) had untolerated taint {spray: mortein}. preemption: 0/2 nodes are available: 2 Preemption is not helpful for scheduling..

7. Create another pod named bee with the nginx image, which has a toleration set to the taint mortein.

    `k run bee --image=nginx --dry-run=client -oyaml`

8. Notice the bee pod was scheduled on node node01 despite the taint.

    `k get po -owide`

9. Do you see any taints on the controplane node?

    `kubectl taint nodes controlplane node-role.kubernetes.io/control-plane:NoSchedule-`

11. What is the state of the pod mosquito now?

    `k get po`

12. Which node is the POD mosquito on now?

    `k get po -owide`