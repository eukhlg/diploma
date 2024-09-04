# Infrastructure
## Terraform
The following infrastructure componets can be deployed to Yandex Cloud with terraform
* Kubernetes nodes (app and master)
* Management server
* Kubernetes cluster (via Kubespray)
* NGINX reverse proxy
* Jenkins

Make sure to set following environment variables before start:
* TF_VAR_token (from [here](https://yandex.cloud/ru/docs/iam/concepts/authorization/oauth-token))
* TF_VAR_cloud_id (from [cloud.yandex.ru](https://console.yandex.cloud/))
* TF_VAR_folder_id (from [cloud.yandex.ru](https://console.yandex.cloud/))

It's also necessary to manually assign static IPs to instances in case of using external DNS names.

## Kubespray
In order to configure Kubespray review/change:
* **build_inventory.sh** 
(example: "for m in {1..3}" means we have 3 master nodes, "for a in {1..2}" for 2 app nodes. This node count should be the same as in terrfaform's main.tf)
* **all.yaml** & **k8s-cluster.yaml** within Kubespray inventory

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

In order to trigger CI/CD pipeline automatically it is necessary to add Webhook URL to repository setting on GitHub.
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
* Create folder /mnt/data/postgres for Postgeres PV

### Secrets

Before applying the ConfigMap for nginx-rp (Reverse Proxy), you need to create a Kubernetes Secret to store the SSL certificate and key.
```
kubectl create secret tls nginx-rp-secret --cert=path/to/tls.crt --key=path/to/tls.key
```



