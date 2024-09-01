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
Install plugins:
 * Multibranch Scan Webhook Trigger
 * Basic Branch Build Strategies
 * Docker Pipeline
 * Docker plugin
 * Kubernetes plugin

Add cregentials for:
* GitHub
* DockerHub
* Kuberenes server

### Kubernetes integration

Use following command to create Jenkins account on Kubernetes server:

```

kubectl create serviceaccount jenkins
kubectl create clusterrolebinding jenkins --clusterrole=cluster-admin --serviceaccount=default:jenkins
kubectl create token jenkins

```


On jenkins server create **Cloud** entry pointing to Kubernetes cluster API URL using credential with secret text above.


