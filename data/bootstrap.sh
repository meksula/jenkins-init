#!/bin/bash

echo 'Jenkins initialize bootstrap script starts to run'

mkdir ~/.ssh

MKDIR_RES=${?}
if [[ "$MKDIR_RES" -eq 1 ]]; then
   echo "Directory for .ssh keys just exist"
elif [[ "$MKDIR_RES" -eq 0 ]]; then
   echo "Directory for .ssh keys created with success"
fi

TARGET_SSH=/home/vagrant/.ssh/
cp /vagrant_data/key/* ${TARGET_SSH}

RESULT=${?}
if [ "${RESULT}" -ne 0 ]
then
   echo "Could not copy SSH keys to ${TARGET_SSH}!"
else
   echo "Keys correcty coppied."
fi

systemctl status jenkins
IS_JENKINS_EXIST=${?}

if [ ${IS_JENKINS_EXIST} -eq 4 ]
then
   sudo yum update
   sudo yum -y install dnf
   sudo dnf search openjdk
   sudo dnf install -y java-11-openjdk
   curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
   sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
   sudo yum install -y jenkins
   sudo systemctl start jenkins

   # Export to shared directory one time initial password to Jenkins
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword >> /vagrant_data/jenkins_pswd
fi

# Free line bellow you could execute after Jenkins installation
# Maybe SSH plugin is required to add keys
JENKINS_HOME="/var/lib/jenkins"
sudo -su jenkins
mkdir ${JENKINS_HOME}/.ssh
mkdir ${JENKINS_HOME}/init.groovy.d

mv /vagrant_data/groovy/* ${JENKINS_HOME}/init.groovy.d/

cp /vagrant_data/key/* ${JENKINS_HOME}/.ssh/
chmod 400 ${JENKINS_HOME}/.ssh/id_rsa

echo "=== Jenkins should be ready for use ==="
