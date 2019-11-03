FROM jenkins/jenkins:lts

COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY jobs/* /usr/share/jenkins/ref/init.groovy.d/

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

RUN mkdir /var/jenkins_home/.ssh
COPY key/* /var/jenkins_home/.ssh/

RUN mkdir /var/jenkins_home/properties
COPY properties/ /var/jenkins/home/properties/

RUN mkdir /var/jenkins_home/resources
COPY resources/ /var/jenkins_home/resources/

RUN sudo apt-get update && \
    apt-get install git vim 

COPY plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
