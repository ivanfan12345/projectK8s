1. We have deployed a POD hosting an application. Inspect it. Wait for it to start.

    `k get po`

2. A user - USER5 - has expressed concerns accessing the application. Identify the cause of the issue.

    `kubectl logs webapp-1 | grep USER5`
    ```
    [2023-06-24 13:28:51,057] WARNING in event-simulator: USER5 Failed to Login as the account is locked due to MANY FAILED ATTEMPTS.
    ```

4. A user is reporting issues while trying to purchase an item. Identify the user and the cause of the issue .Inspect the logs of the webapp in the POD

    `kubectl logs webapp-2 -c simple-webapp`

    `023-06-24 13:31:28,010] WARNING in event-simulator: USER30 Order failed as the item is OUT OF STOCK.