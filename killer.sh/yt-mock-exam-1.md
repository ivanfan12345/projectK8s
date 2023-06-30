# https://www.youtube.com/watch?v=9C31z0sWoqY 

1. You have access to multiple clusters from your main terminal through kubectl contexts. Write all those context names into /opt/course/1/contexts.

    Next write a commond to display the current context into /opt/course/1/context_default_kubectl.sh , the command should use kubectl.

    Finally write a second command doing the same thing into /opt/cousrse/1/context_default_no_kubectl.sh , but without the use of kubectl.

2. Create a single Pod of image `httpd:2.24.41-alpine in NAmespace default. The Pod should be named pod1 and the container should be named pod1-container. This pod should only be scheduled on MASTER Node. DO NOT add new labels on any nodes.

3. There are two Pods named o3db-* in Namespace project-c12. C13 management asked you to scale the Pods down to one replica to save resources. 