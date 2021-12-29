#!/bin/bash
function add_users(){
  for name in ${USERS[@]}
  do
        if grep -q "^$name:" /etc/passwd ; then
          echo "$name exists"
        else
          adduser $name --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password --force-badname
          echo "$name:$USERS_PASSWORD" | chpasswd
          echo "$name created"
        fi
  done
}


add_users &


# Start SSH
service ssh restart && bash

tail -f /dev/null
