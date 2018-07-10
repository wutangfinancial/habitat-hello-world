# Concourse Pipeline Howto

**NOTE:** You need to create concourse-credentials.yml, this file is excluded in ```.gitignore```
```
---
repository: quay.k8s.ford.com/asalowi1/hab-resource
tag: latest
username: asalowi1
password: REDACTED
...
```


```
asalowi1@MGC000002932:~/habitat/habitat-hello-world/linux (Git:* add_concourse_pipeline) > fly -t mylocal set-pipeline -c concourse-pipeline.yml -p habitat-hello-world-linux --load-vars-from concourse-credentials.yml
jobs:
  job habitat-hello-world-linux has been added:
+ name: habitat-hello-world-linux
+ public: true
+ plan:
+ - task: habitat-hello-world
+   config:
+     platform: linux
+     image_resource:
+       type: docker-image
+       source:
+         password: REDACTED
+         repository: quay.k8s.ford.com/asalowi1/hab-resource
+         tag: latest
+         username: asalowi1
+     run:
+       path: echo
+       args:
+       - hello world

apply configuration? [yN]: y
pipeline created!
you can view your pipeline here: http://localhost:8080/teams/main/pipelines/habitat-hello-world-linux

the pipeline is currently paused. to unpause, either:
  - run the unpause-pipeline command
  - click play next to the pipeline in the web ui
```
