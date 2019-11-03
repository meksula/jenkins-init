#!/bin/bash

# Example invoke:
# ./send_over_ssh.sh "root" "51.91.100.185" "/opt/" "send_over_ssh.sh /home/karol/index.html"

USERNAME=$1
HOST_IP=$2
TARGET_DIR=$3
FILES=$4

if [[ ${#} -ne 4 ]]; then
      echo "Invalid arguments amount: ${#}"
      echo "Required arguments amount: 4"
      exit 1
fi

echo "Moving $FILES to ${USERNAME}@${HOST_IP}:${TARGET_DIR}"
scp ${FILES} ${USERNAME}@${HOST_IP}:${TARGET_DIR}

if [[ ${?} -eq 0 ]]; then
      echo 'Correctly coppied files to ${HOST_IP}'
else 
      echo 'Files transfer failed'
      exit 1
fi