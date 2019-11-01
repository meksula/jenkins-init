#!/bin/bash

echo 'Jenkins initialize bootstrap script starts to run'

# cp: cannot create regular file ‘/home/vagrant/dockerfiles//groovy/’: Not a directory

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
   sudo cp /vagrant_data/jenkins-config/ ${DOCKERFILES_HOME}/plugins
}

# Move groovy init scripts and ssh keys for remote git repository
move_keys
move_jenkins_files
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

# Zadania:
# + Tutaj trzeba zbudować i odpalić dockerowy obraz Jenkinsa z Dockerfile
# + W Dockerfile powinna być konfiguracja, która pozwoli przenieść klucze ssh oraz skrypty groovy do odpowiednich katalogów
# + Trzeba też wyłączyć okienko autoryzacyjne 
# - instalacja pluginów automatycznie
# - Pullujemy sobie repozytorium z Job DSL Seed i po prostu dodajemy nowy Job
# - Odpalamy sobie Seed Job
# - Możemy korzystać z Jenkinsa :)

