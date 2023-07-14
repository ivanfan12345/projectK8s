You can access these instructions any time via "Exam Information".


Remote Desktop
In June 2022 the Exam UI changed from a Remote Terminal to a Remote Desktop (Ubuntu XFCE). You're only allowed to use the Firefox browser inside the Remote Desktop to access the K8s Docs, not your local browser. Coming from OSX/Windows there will be changes in copy&paste. There is an article from us describing the new UI and the Linux Foundation released an update. There is also a playground which allows you to test a similar UI.

There are still differences between the real exams and the simulators, like:

You'll need to use the PSI Secure Browser to access the real exams whereas you can use Chrome/Firefox to access the simulators
You can only access certain allowed URLs in the Remote Desktop's Firefox of the real exams whereas there are no such restrictions in the simulators
In the simulators you can use the top navigation Exam Interface to switch back to the old Remote Terminal in case of issues (let us know of any problems on Support), this isn't possible in the real exams

Countdown / Timer
The 120 minutes countdown will start once the session is started. It will be shown on top left. The countdown is just an just an indicator for yourself and won't revoke access to your environment when finished.

Solutions & Score
When the countdown reaches 0 you'll be able to see the proposed solutions for each task and your score. You can also access these earlier by selecting "Exam Controls -> Answers & Score". But it's recommended to try solving by yourself at first.

36hrs Access
You'll have access to your simulator environment during the next 36hrs. You'll always have access to the questions and solutions.

Browser reload or close
For the 36hrs your session will be kept running in the background. You can close the window or even use a different browser without losing changes.

Permissions
You have root permissions using sudo should you encounter any permission issues.

Keyboard issues (some keys won't work)
For OSX it could be your keyboard layout. Please go to Preferences->Keyboard->Input Sources. There search for English and then select "ABC" (or maybe called "Default"). Switching the layout should solve the input issue.
For Windows try to change your keyboard layout to a different English one.
For Ubuntu+Chrome for example users report keyboard issues, switch to Firefox or Chromium. Also open killer.sh in private browser mode.

Clusters
There are three Kubernetes clusters and 8 nodes in total:

cluster1-controlplane1
cluster1-node1
cluster1-node2
cluster2-controlplane1
cluster2-node1
cluster3-controlplane1
cluster3-node1
cluster3-node2
Rules
You're only allowed to have one other browser tab open with:

https://kubernetes.io/docs
https://kubernetes.io/blog
Notepad
Use Application->Accessories->Mousepad to write down notes for yourself during the exam.

Difficulty
This simulator is more difficult than the real certification. We think this gives you a greater learning effect and also confidence to score in the real exam. Most of the simulator scenarios require good amount of work and can be considered "hard". In the real exam you will also face these "hard" scenarios, just less often. There are probably also fewer questions in the real exam.

Make sure
Only edit/modify/delete those resources you want to act on. In most scenarios there are existing resources which could be part of other questions. Just like in a real world cluster.

Content
All simulator sessions of the same type (CKS|CKA|CKAD) will have identical content/scenarios.

Slow or interrupted connection?
If you experience any kind of issues please make sure all points here are complied with:

Browser: only latest Chrome and latest Firefox are supported
Ubuntu+Chrome: users report keyboard issues, switch to Firefox or Chromium
Extensions: disable ALL extensions/plugins and run in private mode
VPN/Proxy: don't use a VPN/Proxy
Internet: use a stable internet connection, with low usage by others
Help / Support
FAQ for answers
Slack for scenario discussions
Support for session/account issues