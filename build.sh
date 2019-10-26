#!/bin/bash

echo '=>  Starting building Jenkins VM environment'

# this flag tell us if we want to install required software in our local machine if not exist
# must equals `--install` or '-i' if we want
INSTALL=$1

detect() {
   IS_EXIST=$(which $1)
   if [[ $? -eq 0 ]]
   then
      echo "==> $1 correctly detected"
   else
      echo "==> $1 is not installed yet"
      install_software $1
   fi
   install_plugins $1
}

install_software() {
   if [[ ("$INSTALL" = "--install") || ("$INSTALL" = "-i") ]]; then
      echo '==> Instalation of required software'
      echo "==> $1 is installing..."
      sudo apt-get install $1
   fi
}   

install_plugins() {
   VAGRANT='vagrant'
   if [[ "$1" = "$VAGRANT" ]]; then
        VBGUEST="vagrant-vbguest"
	   PLUGIN_CHECK=$(vagrant plugin list)
	if [[ "$PLUGIN_CHECK" == *"${VBGUEST}"* ]]; then
	   echo "===> Required plugin correctly installed"
        else
	   echo "===> Cannot detect ${VBGUEST} plugin"
	   vagrant plugin install vagrant-vbguest
        fi
   fi 
}

copy_sensitive_files() {
   FILE=application-prod.yml
   CURRENT=$(pwd)
   FILE_PATH=${CURRENT}/data/key/id_rsa.pub

   if [ ! -f "$FILE_PATH" ]; then
      read -p "Paste here path to id_rsa and id_rsa.pub keys: " KEYS_PATH
      cp $KEYS_PATH/id_rsa* $(pwd)/data/key/
   fi

   FILE_PATH=${CURRENT}/data/properties/crm/application-prod.properties
   if [ ! -f "$FILE_PATH" ]; then
      read -p "===> Paste here full path to $FILE for pcp-crm application: " CRM_PROD_YML
      cp $CRM_PROD_YML $(pwd)/data/properties/crm/
   fi


   FILE_PATH=${CURRENT}/data/properties/accountant/application-prod.properties
   if [ ! -f "$FILE_PATH" ]; then
      read -p "===> Paste here full path to $FILE for pcp-accountant application: " ACCNT_PROD_YML
      cp $ACCNT_PROD_YML $(pwd)/data/properties/accountant/
   fi
}

detect virtualbox
detect vagrant
copy_sensitive_files

# Start to bootstrap virtual machine. Vagrant will download image of VM and starting Jenkins building script
vagrant up
