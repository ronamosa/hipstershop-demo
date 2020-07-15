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
  * [Istio-enabled](#Istio-enabled)
* [Un-Install](#un-installation)

<!-- ABOUT THE PROJECT -->
## About The Project

I wanted a helm chart of [Googles microservices demo](https://github.com/GoogleCloudPlatform/microservices-demo) to deploy and maintain the deployment using helm. That's it.

<!-- GETTING STARTED -->
## Getting Started

Get yourself a copy of the repo: [git@github.com:ronamosa/hipstershop-demo.git](git@github.com:ronamosa/hipstershop-demo.git), and follow the instructions below, depending on your intended setup.

### Prerequisites

#### Local setup: microK8s

Ubuntu:

```sh
sudo snap install microk8s --classic
microk8s.status
```

enable helm version 3

```sh
microk8s.enable helm3
```

#### Remote setup: cloud

TBC

## Installation

### Non-Istio

Do a dry-run first before you deploy to make sure the charts are happy.

The cli convention here is: `helm-command 'install|upgrade --install' '--debug --dry-run' <helm release name> <chart-folder>`

```sh
microk8s.helm3 install --debug --dry-run hipstershop helm/
```

Now, deploy it

```sh
microk8s.helm3 install --debug hipstershop helm/
```

### Istio-enabled

Enable istio in microK8s:

```sh
microk8s.enable istio
```

Enable side-car injection on the namespace where helm chart will be deployed e.g. 'default'

```sh
microk8s.kubectl label namespace default istio-injection=enabled
```

Deploy helm chart

```sh
microk8s.helm3 install --debug hipstershop helm/
```

## Access the Hipster Shop

If your deploy went without error you should be able to run these commands and see the IP addressses of the services you deployed:

for example

```sh
microk8s.kubectl get svc
NAME                    TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
adservice               ClusterIP      10.152.183.33    <none>        9555/TCP       4m
cartservice             ClusterIP      10.152.183.34    <none>        7070/TCP       4m
checkoutservice         ClusterIP      10.152.183.190   <none>        5050/TCP       4m
currencyservice         ClusterIP      10.152.183.243   <none>        7000/TCP       4m
emailservice            ClusterIP      10.152.183.76    <none>        5000/TCP       4m
frontend                ClusterIP      10.152.183.39    <none>        80/TCP         4m
frontend-external       LoadBalancer   10.152.183.140   <pending>     80:31446/TCP   4m
kubernetes              ClusterIP      10.152.183.1     <none>        443/TCP        16d
paymentservice          ClusterIP      10.152.183.137   <none>        50051/TCP      4m
productcatalogservice   ClusterIP      10.152.183.27    <none>        3550/TCP       4m
recommendationservice   ClusterIP      10.152.183.70    <none>        8080/TCP       4m
redis-cart              ClusterIP      10.152.183.107   <none>        6379/TCP       4m
shippingservice         ClusterIP      10.152.183.47    <none>        50051/TCP      4m
```

Open your browser to `http://10.152.183.39` (frontend) or `http://10.152.183.140` (frontend-external)

## Patch frontend-external

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
