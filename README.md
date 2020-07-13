<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

# Helm Chart: Google Microservices Demo

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- TABLE OF CONTENTS -->
## Table of Contents

* [About the Project](#about-the-project)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
  * [Usage](#usage)
  * [Un-Installation](#un-installation)

<!-- ABOUT THE PROJECT -->
## About The Project

I wanted a helm chart of [Googles microservices demo](https://github.com/GoogleCloudPlatform/microservices-demo) to deploy and maintain the deployment using helm. That's it.

<!-- GETTING STARTED -->
## Getting Started

Get yourself a copy of the repo: [git@github.com:ronamosa/hipstershop-demo.git](git@github.com:ronamosa/hipstershop-demo.git), and follow the instructions below, depending on your intended setup.

### Prerequisites

#### local setup: microK8s

Ubuntu:

```sh
sudo snap install microk8s --classic
microk8s.status
```

enable services: helm3, istio service mesh, k8s dashboard

```sh
microk8s.enable helm3 istio dashboard
```

#### remote setup: cloud

TBC

### Installation

Do a dry-run first before you deploy to make sure the charts are happy.

The cli convention here is: `helm-command 'install|upgrade --install' '--debug --dry-run' <helm release name> <chart-folder>`

```sh
microk8s.helm3 install --debug --dryrun hipstershop helm/
```

Now, deploy it

```sh
microk8s.helm3 install --debug hipstershop helm/
```

Secondly you can make the hipster store accessible from your LAN using your local machines LAN IP.

To do this you need to patch the LoadBalancer service `frontend-external`

### patch 'frontend-external'

If you want to expose your shop deployment to your LAN (the network your PC is on) use the following command to patch the `frontend-external` service to your machines IP address

`kubectl patch svc frontend-external -n hipster-shop -p '{"spec": {"type": "LoadBalancer", "externalIPs":["<ip-address of masternode>"]}}'`

for example, have look at your k8s services

```sh
$ microk8s.kubectl get svc

NAME                    TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
adservice               ClusterIP      10.152.183.183   <none>        9555/TCP       3h26m
cartservice             ClusterIP      10.152.183.238   <none>        7070/TCP       3h26m
checkoutservice         ClusterIP      10.152.183.124   <none>        5050/TCP       3h26m
currencyservice         ClusterIP      10.152.183.247   <none>        7000/TCP       3h26m
emailservice            ClusterIP      10.152.183.90    <none>        5000/TCP       3h26m
frontend                ClusterIP      10.152.183.13    <none>        80/TCP         3h26m
frontend-external       LoadBalancer   10.152.183.172   <pending>     80:30829/TCP   3h26m
kubernetes              ClusterIP      10.152.183.1     <none>        443/TCP        11d
paymentservice          ClusterIP      10.152.183.207   <none>        50051/TCP      3h26m
productcatalogservice   ClusterIP      10.152.183.22    <none>        3550/TCP       3h26m
recommendationservice   ClusterIP      10.152.183.165   <none>        8080/TCP       3h26m
redis-cart              ClusterIP      10.152.183.8     <none>        6379/TCP       3h26m
shippingservice         ClusterIP      10.152.183.46    <none>        50051/TCP      3h26m
```

get your computers IP address (e.g. 192.168.1.11)

run the patch: `microk8s.kubectl patch svc frontend-external -p '{"spec": {"type": "LoadBalancer", "externalIPs":["192.168.1.11"]}}'`

check out your k8s services again

```sh
$ microk8s.kubectl get svc
NAME                    TYPE           CLUSTER-IP       EXTERNAL-IP    PORT(S)        AGE
adservice               ClusterIP      10.152.183.183   <none>         9555/TCP       6h45m
cartservice             ClusterIP      10.152.183.238   <none>         7070/TCP       6h45m
checkoutservice         ClusterIP      10.152.183.124   <none>         5050/TCP       6h45m
currencyservice         ClusterIP      10.152.183.247   <none>         7000/TCP       6h45m
emailservice            ClusterIP      10.152.183.90    <none>         5000/TCP       6h45m
frontend                ClusterIP      10.152.183.13    <none>         80/TCP         6h45m
frontend-external       LoadBalancer   10.152.183.172   192.168.1.11   80:30829/TCP   6h45m
kubernetes              ClusterIP      10.152.183.1     <none>         443/TCP        11d
paymentservice          ClusterIP      10.152.183.207   <none>         50051/TCP      6h45m
productcatalogservice   ClusterIP      10.152.183.22    <none>         3550/TCP       6h45m
recommendationservice   ClusterIP      10.152.183.165   <none>         8080/TCP       6h45m
redis-cart              ClusterIP      10.152.183.8     <none>         6379/TCP       6h45m
shippingservice         ClusterIP      10.152.183.46    <none>         50051/TCP      6h45m
```

Now, open `http://192.168.1.11:30829` and you will see the hipster shop.

### Usage

Commands to interact with your cluster:

```sh
microk8s.kubectl get pods,svc
microk8s.kubectl describe pods <pod-name>
microk8s.kubectl logs <pod-name>
```

When you make changes to the the chart and need to re-deploy it

```sh
microk8s.helm3 upgrade --install --debug hipstershop helm/
```

### StackDriver errors

If you see the recommendationservice pod 'CrashLooping', check the logs and if they are talking about `'GOOGLE_APPLICATION_CREDENTIALS'` being missing you have two choices:

1. Get your creds from your GCP account, save them as a .json file, and then run `'export GOOGLE_APPLICATION_CREDENTIALS=/path/to/json/file'`, and now your stackdriver should be ok.
2. Disable the functions in the microservice that needs stackdriver

make sure your `'recommendationservice/templates/deployment.yaml'` has these uncommented

```yaml
  - name: DISABLE_TRACING
    value: "1"
  - name: DISABLE_PROFILER
    value: "1"
  - name: DISABLE_DEBUGGER
    value: "1"
```

### Un-Installation

Uninstallation is really easy with helm, run this command and watch (only if you want to) the pods terminate and everything deployed by helm will be removed (remember the release name for the example is 'hipstershop'):

```sh
microk8s.helm3 delete hipstershop
```

## Contact

Ron Amosa - [@iamronamosa](https://twitter.com/iamronamosa) - ron@cloudbuilder.io

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/ronamosa/hipstershop-demo.svg?style=flat-square
[contributors-url]: https://github.com/ronamosa/hipstershop-demo/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ronamosa/hipstershop-demo.svg?style=flat-square
[forks-url]: https://github.com/ronamosa/hipstershop-demo/network/members
[stars-shield]: https://img.shields.io/github/stars/ronamosa/hipstershop-demo.svg?style=flat-square
[stars-url]: https://github.com/ronamosa/hipstershop-demo/stargazers
[issues-shield]: https://img.shields.io/github/issues/ronamosa/hipstershop-demo.svg?style=flat-square
[issues-url]: https://github.com/ronamosa/hipstershop-demo/issues
[license-shield]: https://img.shields.io/github/license/ronamosa/hipstershop-demo.svg?style=flat-square
[license-url]: https://github.com/ronamosa/hipstershop-demo/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=flat-square&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/ron-amosa
