# Zero-Downtime Blue/Green VM Deployments with Managed Instance Groups, Cloud Build & Terraform<br><sub>*a Google Cloud Platform Demo*</sub>

## Summary

This repository provides source code for zero-downtime blue/green VM deployments using Cloud Build and Terraform.

It configures multiple regional external HTTP(S) load balancers and deploys a demo application to Compute Engine VMs in managed instance groups (MIGs). It adds Cloud Build triggers to start deployment automatically when configuration file changes in Source Code Repository.

You can watch the video of this demo running and follow the code walkthrough. You can also run this demo in your own project.

## Video: Live Demo & Code Walkthrough

[<img src="img/video.png" width="100%">](https://youtu.be/7-jO5OGPUxM)

## Do It Yourself

> **Warning**
>
> This project is for **advanced** Google Cloud Platform infrastructure developers and SRE. If you decide to clone and run any code from this repository, **you will be billed** for the real infrastructure it creates. We rely on unattended automation, which can make it difficult for you to manage your project manually. We use custom VPCs with public IP addresses, which can make your project **vulnerable to attacks**. If you are a novice GCP user and just want to learn -- watch the video above instead.

> **Note**
>
> Take a pause here if you are a developer in a large enterprise company that already uses Google Cloud Platform. Remember that all your projects are subject to foundational setup of your organization and its landing zones ([link](https://cloud.google.com/architecture/landing-zones)). There maybe org policy restrictions (for example: on using regions or external IP addresses) that will break this demo. Reach out to the team that manages GCP in your organization to discuss where and how you can run this demo following their policies.

Anyone can run this demo on their own. Here is how:

* create new Google Cloud Platform project
* enable billing, which is required
* install `gcloud` CLI ([link](https://cloud.google.com/sdk/docs/install)) or use your project Cloud Shell
* set SDK default project, by executing
  ```
  gcloud config set project <YOUR_PROJECT_ID>
  ```
* execute setup script
  * run it directly from our GitHub repo:
    ```
    bash <(curl https://raw.githubusercontent.com/psimakov/gcp-mig-simple/main/setup.sh)
    ```
  * or, fetch, review, and then run it:
    ```
    curl https://raw.githubusercontent.com/psimakov/gcp-mig-simple/main/setup.sh -o setup.sh
    bash ./setup.sh
    ```
* follow on-screen instructions
* trigger deployment by committing configuration change
  ```
  mkdir ~/work
  cd ~/work
  gcloud source repos clone copy-of-gcp-mig-simple
  cd ./copy-of-gcp-mig-simple

  nano infra/main.tfvars

  git add .
  git commit -m "Promote green"
  git push
  ```
* visit Cloud Build History page to see progress of execution
* review Cloud Build apply pipeline logs for deployment IP addresses
* at the end, delete all created resources
  ```
  bash <(curl https://raw.githubusercontent.com/psimakov/gcp-mig-simple/main/teardown.sh)
  ```

Good luck!

## Slides

<img src="img/title.png" width="100%">

### Technical Architecture

#### High level architecture of generic blue/green deployment
<img src="img/bg.png" width="100%">

#### Detailed architecture of regional external HTTP(S) load balancer with managed instance group (MIG) backend ([link](https://cloud.google.com/load-balancing/docs/https/setting-up-reg-ext-https-lb))

<img src="img/mig.png" width="100%">

#### Detailed architecture of DevOps workflow
<img src="img/devops.png" width="100%">

### Bootstrapping

#### Setup shell script is executed by developer
<img src="img/setup.png" width="100%">

#### Bootstrap Cloud Build is executed
<img src="img/boot.png" width="100%">

#### Cloud Source Repository is created
<img src="img/csr.png" width="100%">

#### Cloud Build triggers are created
<img src="img/cloud-build-triggers.png" width="100%">

### GitOps Deployment

#### Deployment is triggered when developer commits configuration change
<img src="img/gitops.png" width="100%">

#### Cloud Build applies Terraform plan
<img src="img/pipeline-apply.png" width="100%">

#### All application serving components including three load balancers, blue and green MIGs and their VMs are now live
<img src="img/live.png" width="100%">

#### Managed instance groups (MIGs) were created
<img src="img/migs.png" width="100%">

#### Virtual machine instances (VMs) have started
<img src="img/vms.png" width="100%">

#### External IP addresses were assigned
<img src="img/ips.png" width="100%">

### Clean Up

#### Cloud Build destroys Terraform plan when developer triggers it manually
<img src="img/pipeline-destroy.png" width="100%">

#### All resources managed by Terraform are destroyed, but Cloud Build execution history is preserved
<img src="img/cloud-build-history.png" width="100%">

#### Teardown shell script is executed by developer, deleting Cloud Source Repository and Cloud Build triggers
<img src="img/teardown.png" width="100%">
