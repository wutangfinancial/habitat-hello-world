# Concourse Pipeline for Habitat Packages - Howto

## Requirements

- A running Concourse instance (local, local VM, Docker, Lab, or EDC should all work the same) - https://concourse-ci.org/download.html
- The ```fly``` command is used to interact with a running Concourse instance - https://concourse-ci.org/download.html
- Access to [Ford GitHub](https://github.ford.com), with a functioning [SSH Key](https://github.ford.com/settings/keys) added to your profile to enable you to clone repos
- Access to the [Ford Quay](https://quay.k8s.ford.com)
- Access to the Internal Ford [Habitat Builder](http://ito000604.fhc.ford.com/#/pkgs/core)

## Setting up Concourse

Here are some some docs on how to get started with Concourse

- https://gist.github.ford.com/ASALOWI1/c929bf55eba9b92c99e4294c53187b58
- https://github.ford.com/NGSE/cloud_iaas/tree/master/concourse
- https://concourse-ci.org/getting-started.html
- https://concoursetutorial.com/

## Ford Quay

Not all Concourse instances will have direct Internet access thru the proxy, especially since Concourse seems to use docker under the covers to download docker images on which it runs jobs. It's not clear how to configure the embedded docker instance to use the proxy.  

Here are the steps I did to build the hab-resource Docker image from the cloud_iaas repo, and push it to my internal quay.k8s.ford.com repository:
- https://gist.github.ford.com/ASALOWI1/c929bf55eba9b92c99e4294c53187b58#getting-this-to-work-in-ford
- https://gist.github.ford.com/ASALOWI1/6156f0203ba711a97dfcf4b32adae192

## Credentials and Secrets

**These should not be stored in GitHub.**  Therefore, you need to create ```~/.my-concourse-credentials.yml```, this file is *NOT* included in this git repo.  You don't have to put this file in your home directory, it can be saved anywhere.  Please note the 8 spaces (4 tabs) indent o the private_key, yaml files are very picky.
```
---
quay_username: asalowi1
quay_password: hashed_password_from_quay.k8s.ford.com
private_key: |
         -----BEGIN RSA PRIVATE KEY-----
         M453dkfadf/jakjfa...
         3fqQHFDdf/jakjfa5...
         ...
         ...
         -----END RSA PRIVATE KEY-----
...
```

## The pipeline

This first iteration of the pipeline will
1. Clone a github repo with a Habitat package
1. Pull and start a Docker instance of hab-resource (The repository/image and tag is hard coded so as to be visible in yaml)
1. echo "Hello, World!"

## How to run the pipeline

Login, sync, status, and list targets:
```
> fly --target concoursedev login --concourse-url <concourse instance>
logging in to team 'main'

username: admin
password:
target saved
```
```
fly -t concoursedev sync
version 3.14.1 already matches; skipping
```
```
> fly -t concoursedev status
logged in successfully
```
```
> fly targets list
name          url                                     team  expiry
concoursedev  http://REDACTED:8080                    main  Wed, 11 Jul 2018 20:46:19 UTC
mydocker      http://127.0.0.1:8080                   main  Wed, 04 Jul 2018 17:54:37 UTC
mylab2316     http://REDACTED                         main  Wed, 11 Jul 2018 15:23:25 UTC
mylocal       http://localhost:8080                   main  Wed, 11 Jul 2018 14:32:46 UTC
```

Set the Pipeline:
```
> fly -t concoursedev set-pipeline -p asalowi1-habitat-hello-world-linux -c concourse-pipeline.yml --load-vars-from ~/.my-concourse-credentials.yml
resources:
  resource habitat-hello-world-git has been added:
+ name: habitat-hello-world-git
+ type: git
+ source:
+   branch: master
+   private_key: |
+     -----BEGIN RSA PRIVATE KEY-----
+     REDACTED
+     -----END RSA PRIVATE KEY-----
+   uri: git@github.ford.com:ASALOWI1/habitat-hello-world.git
+ check_every: 1m

jobs:
  job asalowi1-habitat-hello-world-linux-pipeline has been added:
+ name: asalowi1-habitat-hello-world-linux-pipeline
+ public: true
+ plan:
+ - get: habitat-hello-world-git
+ - task: concourse-echo-hello-world
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
+       - Hello World!

apply configuration? [yN]: y
pipeline created!
you can view your pipeline here: http://localhost:8080/teams/main/pipelines/habitat-hello-world-linux

the pipeline is currently paused. to unpause, either:
  - run the unpause-pipeline command
  - click play next to the pipeline in the web ui
```

Log into Your Concourse instance web GUI and unpause the pipeline and see if it worked!
1. Browse to the Concourse intance and login on the top right (team "main")
1. Toggle the menu button (3 horizontal bars) on the top left to see all the pipelines in this team instance
1. Select and Unpause your new pipeline by clicking the Play button
1. Double click on the pipeline name to see the job output
1. Click the + on the top right to start a Build.
1. Output will be displayed on screen

Destroy your pipeline to cleanup when you are done:
```
> fly -t concoursedev destroy-pipeline -p asalowi1-habitat-hello-world-linux
!!! this will remove all data for pipeline `asalowi1-habitat-hello-world-linux`

are you sure? [yN]: y
`asalowi1-habitat-hello-world-linux-pipeline` deleted
```

Logout of your target:
```
> fly -t concoursedev logout
logged out of target: concoursedev
```
