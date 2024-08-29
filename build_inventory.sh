#!/bin/bash

set -e

printf "[all]\n"

for m in {1..1}
do
printf "k8s-master-$m  ansible_host="
terraform output -json k8s_master_external_ip_address | jq -j ".[$m-1]"
printf "   ip="
terraform output -json k8s_master_internal_ip_address | jq -j ".[$m-1]"
printf "   etcd_member_name=etcd-$m\n"
done

for a in {1..1}
do
printf "k8s-app-$a   ansible_host="
terraform output -json k8s_app_external_ip_address | jq -j ".[$a-1]"
printf "   ip="
terraform output -json k8s_app_internal_ip_address | jq -j ".[$a-1]"
printf "\n"
done

printf "\n[all:vars]\n"
printf "ansible_user=admin\n"
#printf "supplementary_addresses_in_ssl_keys='"
#terraform output -json k8s_master_external_ip_address | jq -cj
printf "\n\n"

printf "[kube-master]\n"
for m in {1..1}
do
printf "k8s-master-$m\n"
done

printf "\n[etcd]\n"
for m in {1..1}
do
printf "k8s-master-$m\n"
done

printf "\n[kube-node]\n"
for a in {1..1}
do
printf "k8s-app-$a\n"
done

cat << EOF

[calico-rr]

[k8s-cluster:children]
kube-master
kube-node
calico-rr
EOF
