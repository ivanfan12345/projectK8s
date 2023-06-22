1. A pod called rabbit is deployed. Identify the CPU requirements set on the Pod

    `k describe po rabbit`

2. Delete the rabbit pod.

    `k delete po rabbit`

3. The status OOMKilled indicates that it is failing because the pod ran out of memory. Identify the memory limit set on the POD.

5. The elephant pod runs a process that consumes 15Mi of memory. Increase the limit of the elephant pod to 20Mi.

