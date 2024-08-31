FROM jenkins/jenkins:lts
USER root
RUN curl -fsSL https://get.docker.com | sh
USER root
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
