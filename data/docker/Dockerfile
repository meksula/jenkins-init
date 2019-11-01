FROM jenkins/jenkins:lts

COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

RUN mkdir /var/jenkins_home/.ssh
COPY key/* /var/jenkins_home/.ssh/
