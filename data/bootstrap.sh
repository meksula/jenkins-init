#!/bin/bash

echo 'Jenkins initialize bootstrap script starts to run'

HOME_DIR="/home/vagrant"
SSH_DIR="/home/vagrant/.ssh"

if [[ ! -d "$HOME_DIR" ]]; then
   sudo mkdir $HOME_DIR
fi 

DOCKERFILES_HOME=${HOME_DIR}/dockerfiles/

if [[ ! -f /vagrant_data/docker/Dockerfile ]]; then
   echo "Critical error occurred and cannot find Dockerfile in exchange space!"
   exit 1
else 
   sudo mkdir ${DOCKERFILES_HOME}
   sudo cp /vagrant_data/docker/Dockerfile ${DOCKERFILES_HOME}
   if [[ ! -f "${DOCKERFILES_HOME}/Dockerfile" ]]; then
      echo "Dockerfile not exist! File was not copied from exchange space"
   fi
fi

move_keys() {
   if [[ -f "/vagrant_data/key/id_rsa" ]]; then
      if [[ ! -d "${DOCKERFILES_HOME}/key" ]]; then
         sudo mkdir ${DOCKERFILES_HOME}/key
      fi
      sudo cp /vagrant_data/key/* ${DOCKERFILES_HOME}/key
   else 
      echo "Keys not detected in exchange space. Attach them or other credentials after bootstraping process"
   fi
}

move_jenkins_files() {
   mkdir ${DOCKERFILES_HOME}/groovy
   mkdir ${DOCKERFILES_HOME}/plugins
   sudo cp /vagrant_data/groovy/* ${DOCKERFILES_HOME}/groovy
   sudo cp /vagrant_data/jenkins_config/* ${DOCKERFILES_HOME}/plugins
}

move_job_dsl() {
   mkdir ${DOCKERFILES_HOME}/jobs
   sudo cp /vagrant_data/jenkins_jobs/* ${DOCKERFILES_HOME}/jobs
   if [[ "${?}" -eq 0 ]]; then
      echo "Job DSL scripts copied correctly"
   else
      echo "Job DSL scripts copy failed"
   fi
}

move_resources() {
   mkdir ${DOCKERFILES_HOME}/resources
   mkdir ${DOCKERFILES_HOME}/properties
   sudo cp /vagrant_data/resources/ ${DOCKERFILES_HOME}/resources
   sudo cp /vagrant_data/properties/ ${DOCKERFILES_HOME}/properties
}

# Move groovy init scripts and ssh keys for remote git repository
move_keys
move_jenkins_files
move_job_dsl
move_resources

sudo yum update

# Docker installation
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce
sudo usermod -aG docker $(whoami)
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Run Docker Image
cd ${DOCKERFILES_HOME}

sudo docker build -t jenkins .
sudo docker run -u root --rm -d -p 8080:8080 -p 50000:50000 -v jenkins-data/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins
sudo docker ps
