# hipstershop-demo

helm chart of Googles microservices demo (https://github.com/GoogleCloudPlatform/microservices-demo)

## local k8s: disable options

if you don't have a GCP account with stackdriver available, disable these in `recommendationservice/templates/deployment.yaml`

```yaml
  - name: DISABLE_TRACING
    value: "1"
  - name: DISABLE_PROFILER
    value: "1"
  - name: DISABLE_DEBUGGER
    value: "1"
```

## stackdriver google authentication

set this in your env vars before deploying, affects recommendation service:

`export GOOGLE_APPLICATION_CREDENTIALS="[PATH]"`

## helm deploy

### dry run (test)

`microk8s.helm3 install --debug --dry-run hipstershop helm/`

### deploy

`microk8s.helm3 install --debug hipstershop helm/`

## patch frontend-external

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
adservice               ClusterIP      10.152.183.183   <none>         9555/TCP       3h30m
cartservice             ClusterIP      10.152.183.238   <none>         7070/TCP       3h30m
checkoutservice         ClusterIP      10.152.183.124   <none>         5050/TCP       3h30m
currencyservice         ClusterIP      10.152.183.247   <none>         7000/TCP       3h30m
emailservice            ClusterIP      10.152.183.90    <none>         5000/TCP       3h30m
frontend                ClusterIP      10.152.183.13    <none>         80/TCP         3h30m
frontend-external       LoadBalancer   10.152.183.172   192.168.1.11   80:30829/TCP   3h30m
kubernetes              ClusterIP      10.152.183.1     <none>         443/TCP        11d
paymentservice          ClusterIP      10.152.183.207   <none>         50051/TCP      3h30m
productcatalogservice   ClusterIP      10.152.183.22    <none>         3550/TCP       3h30m
recommendationservice   ClusterIP      10.152.183.165   <none>         8080/TCP       3h30m
redis-cart              ClusterIP      10.152.183.8     <none>         6379/TCP       3h30m
shippingservice         ClusterIP      10.152.183.46    <none>         50051/TCP      3h30m
```

open `http://192.168.1.11:30829` and you will see the hipster shop.