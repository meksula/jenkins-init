FROM jenkins/jenkins:2.60.2

COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY jobs/seed_job.groovy /usr/share/jenkins/ref/init.groovy.d/seed_job.groovy

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

RUN mkdir /var/jenkins_home/.ssh
COPY key/* /var/jenkins_home/.ssh/

COPY plugins/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN xargs /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
