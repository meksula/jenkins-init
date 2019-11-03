FROM jenkins/jenkins:lts

COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY jobs/* /usr/share/jenkins/ref/init.groovy.d/

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

RUN mkdir /var/jenkins_home/properties
COPY properties/ /var/jenkins/home/properties/

RUN mkdir /var/jenkins_home/resources
COPY resources/ /var/jenkins_home/resources/

COPY plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER root

RUN mkdir /root/.ssh
COPY key/* /root/.ssh/
RUN chmod 600 /root/.ssh/id_rsa /root/.ssh/id_rsa.pub

RUN apt-get update && \
    apt-get install -y git vim wget curl nmap