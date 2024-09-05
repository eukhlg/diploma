# Infrastructure
## Terraform
The following infrastructure componets are deployed automatically to Yandex Cloud with terraform
* Kubernetes nodes (app and master)
* Management server
* Kubernetes cluster (via Kubespray)
* NGINX reverse proxy for Management server
* Jenkins
* GPLAB stack

Make sure to set following environment variables before start:
* TF_VAR_token (from [here](https://yandex.cloud/ru/docs/iam/concepts/authorization/oauth-token))
* TF_VAR_cloud_id (from [cloud.yandex.ru](https://console.yandex.cloud/))
* TF_VAR_folder_id (from [cloud.yandex.ru](https://console.yandex.cloud/))

It's also necessary to manually assign static IPs to instances and add DNS records.

## Kubespray
In order to configure Kubespray review/change:
* **build_inventory.sh** 
(note: "for m in {1..3}" means we have 3 master nodes, "for a in {1..2}" for 2 app nodes. This node count should be the same as in terrfaform's main.tf)
* **all.yaml** & **k8s-cluster.yaml** within Kubespray inventory

## NGINX Reverse proxy
### SSL certificates

Make sure to put fullchain.pem and private.key certs to nginx/certs forlder

## Jenkins

### Pipeline
* Create multibranch pipeline
* Add **discover tag** beheviours
* Add container repository credentials (DockerHub)

### Plugins
* Multibranch Scan Webhook Trigger
* Basic Branch Build Strategies
* Docker Pipeline
* Kubernetes
* Kubernetes CLI

### Credentials
* GitHub
* DockerHub
* Kuberenes cluster API

### Webhook

In order to trigger CI/CD pipeline automatically add Webhook URL to repository settings on GitHub.
It should look as follows:

https://<jenkins.my.domain>/multibranch-webhook-trigger/invoke?token=<your token>

Same token to be user in pipeline settings in Jenkins.

## Kubernetes
### Service account
* Use following command to create Jenkins account on Kubernetes cluster:

```
kubectl create serviceaccount jenkins
kubectl create clusterrolebinding jenkins --clusterrole=cluster-admin --serviceaccount=default:jenkins
kubectl create token jenkins --duration 131072h #15 years token
```

* On Jenkins server create **Cloud** entry pointing to Kubernetes cluster API URL using token as **secret text** credentials type.

### Persistent volume
* Create folder /mnt/data/postgres for Postgeres PV on worker nodes

### Secrets

Before applying the ConfigMap for nginx-rp (Reverse Proxy), you need to create a Kubernetes Secret to store the SSL certificate and key.
```
kubectl create secret tls nginx-rp-secret --cert=path/to/fullchain.crt --key=path/to/private.key
```
### Helm

Install helm to control plane node:
```
cd /tmp && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```
## GPLAB

Logging and monitoring stack includes:

* **G**rafana
* **P**rometheus
* **L**oki
* **A**lert Manager
* **B**lackbox exporter

### Grafana Loki

Loki installed to the Kubernetes cluster with command:
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki-stack --namespace loki --create-namespace
kubectl apply -f loki-loadbalancer.yaml
```
Fix error **"Grafana Loki Liveness probe failed: HTTP probe failed with status code: 503"**
```
kubectl edit statefulset loki -n loki
# need to change image: grafana:/loki:2.9.7
```

### Grafana

Following sources should be added to Grafana:

* prometheus:9000
* alertmanager:9093
* k8s-app-1:<loki_loadbalanced_port>

Following dashbords should be added to Grafana:

* Node Exporter
* Blackbox Exporter
* Loki Kubernetes Logs

