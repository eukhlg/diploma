FROM jenkins/jenkins:lts
USER root
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow" "multibranch-scan-webhook-trigger" "basic-branch-build-strategies" "docker-workflow" "kubernetes" "kubernetes-cli"
RUN cd /tmp && curl -fsSL https://get.docker.com | sh
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && chmod 700 /tmp/get_helm.sh && ./get_helm.sh
