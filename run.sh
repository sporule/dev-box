#!/bin/bash

function add_users(){
  for name in ${USERS[@]}
  do
        adduser $name --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password --force-badname
        echo "$name:$USERS_PASSWORD" | chpasswd
  done
}

add_users &

# Run Jupyter Hub if it is enabled
if [ "$JUPYTER" = "1" ]; then (jupyterhub --port=8080 &) ; fi


# Start SSH
service ssh restart && bash

tail -f /dev/null
