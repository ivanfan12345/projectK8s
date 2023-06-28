1. Troubleshooting Test 1: A simple 2 tier application is deployed in the alpha namespace. It must display a green web page on success. Click on the App tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue.

    Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    ![Alt text](app-fail.png)
    
    The service name used for the MySQL Pod is incorrect. According to the Architecture diagram, it should be mysql-service.

    To fix this, first delete the current service: kubectl -n alpha delete svc mysql

    Then create a new service with the following YAML file (or use imperative command):
    ```
    ---
    apiVersion: v1
    kind: Service
    metadata:
    name: mysql-service
    namespace: alpha
    spec:
        ports:
        - port: 3306
        targetPort: 3306
        selector:
        name: mysql
    ```

    Create the new service: `kubectl create -f <service.yaml>`

2. Troubleshooting Test 2: The same 2 tier application is deployed in the beta namespace. It must display a green web page on success. Click on the App tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue.

    Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    `k config set-context --current --namespace=beta`

    If you inspect the mysql-service in the beta namespace, you will notice that the targetPort used to create this service is incorrect.

    Compare this to the Architecture diagram and change it to 3306. Update the mysql-service as per the below YAML:
    ```
    apiVersion: v1
    kind: Service
    metadata:
    name: mysql-service
    namespace: beta
    spec:
        ports:
        - port: 3306
        targetPort: 3306
        selector:
        name: mysql
    ```

3. Troubleshooting Test 3: The same 2 tier application is deployed in the gamma namespace. It must display a green web page on success. Click on the App tab at the top of your terminal to view your application. It is currently failed or unresponsive. Troubleshoot and fix the issue. Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    `Environment Variables: DB_Host=mysql-service; DB_Database=Not Set; DB_User=root; DB_Password=paswrd; 2003: Can't connect to MySQL server on 'mysql-service:3306' (111 Connection refused)
From webapp-mysql-5456999f7b-jpqs8!`

    Inspect the selector used by the mysql-service. Is it correct?

    If you inspect the mysql-service, you will see that that the selector used does not match the label on the mysql pod.
    ```
    Service:
    ```
    root@controlplane:~# kubectl -n gamma describe svc mysql-service | grep -i selector
    Selector:          name=sql00001
    root@controlplane:~#
    Pod:
    ```
    root@controlplane:~# kubectl -n gamma describe pod mysql | grep -i label   
    Labels:       name=mysql
    root@controlplane:~#
    ```
    As you can see the selector used is name=sql001 whereas it should be name=mysql.
    Update the mysql-service to use the correct selector as per the below YAML:
    ```

    ---
    apiVersion: v1
    kind: Service
    metadata:
    name: mysql-service
    namespace: gamma
    spec:
        ports:
        - port: 3306
        targetPort: 3306
        selector:
        name: mysql
    ```

4. Troubleshooting Test 4: The same 2 tier application is deployed in the delta namespace. It must display a green web page on success. Click on the App tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue. Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    `Environment Variables: DB_Host=mysql-service; DB_Database=Not Set; DB_User=sql-user; DB_Password=paswrd; 1045 (28000): Access denied for user 'sql-user'@'10.42.0.16' (using password: YES)
From webapp-mysql-7774849c84-268nn!`

    Try accessing the web application from the browser using the tab called app. You will notice that it cannot connect to the MySQL database:

    ```
    Environment Variables: DB_Host=mysql-service; DB_Database=Not Set; DB_User=sql-user`DB_Password=paswrd; 1045 (28000): Access denied for user 'sql-user'@'10.244.1.9' (using password: YES)
    ```

    According to the architecture diagram, the DB_User should be root but it is set to sql-user in the webapp-mysql deployment.

    Use the command `kubectl -n delta edit deployments.apps webapp-mysql` and update the environment variable as follows:
    ```
    spec:
        containers:
        - env:
            - name: DB_Host
            value: mysql-service
            - name: DB_User
            value: root
            - name: DB_Password
            value: paswrd
    ```

    This will recreate the pod and you should then be able to access the application.

5. Troubleshooting Test 5: The same 2 tier application is deployed in the epsilon namespace. It must display a green web page on success. Click on the App tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue.

    `Environment Variables: DB_Host=mysql-service; DB_Database=Not Set; DB_User=sql-user; DB_Password=paswrd; 1045 (28000): Access denied for user 'sql-user'@'10.42.0.21' (using password: YES)
From webapp-mysql-7774849c84-pjkg9!`


    If you inspect the environment variable called MYSQL_ROOT_PASSWORD, you will notice that the value is incorrect as compared to the architecture diagram: -

    ```

    root@controlplane:~# kubectl -n epsilon describe pod mysql  | grep MYSQL_ROOT_PASSWORD 
        MYSQL_ROOT_PASSWORD:  passwooooorrddd
    root@controlplane:~#
    ```

    Correct this by deleting and recreating the mysql pod with the correct environment variable as follows: -
    ```

    spec:
    containers:
    - env:
        - name: MYSQL_ROOT_PASSWORD
        value: paswrd
    ```
    Also edit the webapp-mysql deployment and make sure that the DB_User environment variable is set to root as follows: -
    ```
    spec:
        containers:
        - env:
        - name: DB_Host
            value: mysql-service
        - name: DB_User
            value: root
        - name: DB_Password
            value: paswrd
    ```
    Once the objects are recreated, and you should be able to access the application.

6. Troubleshooting Test 6: The same 2 tier application is deployed in the zeta namespace. It must display a green web page on success. Click on the App tab at the top of your terminal to view your application. It is currently failed. Troubleshoot and fix the issue. 
    Stick to the given architecture. Use the same names and port numbers as given in the below architecture diagram. Feel free to edit, delete or recreate objects as necessary.

    `502 Bad Gateway: nginx/1.21.1`

    There are a few things wrong in this setup:

    1. If you inspect the web-service, you will see that the nodePort used is incorrect.
    This service should be exposed on port 30081 and NOT 30088.
    ```
    root@controlplane:~# kubectl -n zeta get svc web-service 
    NAME          TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
    web-service   NodePort   10.102.190.212   <none>        8080:30088/TCP   3m1s
    root@controlplane:~#
    ```


    To correct this, delete the service and recreate it using the below YAML file:
    ```

    ---
    apiVersion: v1
    kind: Service
    metadata:
    name: web-service
    namespace: zeta
    spec:
    ports:
    - nodePort: 30081
        port: 8080
        targetPort: 8080
    selector:
        name: webapp-mysql
    type: NodePort

    ```

    2. Also edit the webapp-mysql deployment and make sure that the DB_User environment variable is set to root as follows: -
    ```

    spec:
        containers:
        - env:
        - name: DB_Host
            value: mysql-service
        - name: DB_User
            value: root
        - name: DB_Password
            value: paswrd
    ```


    3. The DB_Password used by the mysql pod is incorrect. Delete the current pod and recreate with the correct environment variable as per the snippet below: -
    ```

    spec:
    containers:
    - env:
        - name: MYSQL_ROOT_PASSWORD
        value: paswrd
    ```


    Once the objects are recreated, and you should be able to access the application.