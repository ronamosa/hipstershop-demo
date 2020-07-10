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

Get the IP address of the master node and use it as the external IP for the frontend-external service so you can access the local k8s cluster from your machine:

`kubectl patch svc frontend-external -n hipster-shop -p '{"spec": {"type": "LoadBalancer", "externalIPs":["<ip-address of masternode>"]}}'`