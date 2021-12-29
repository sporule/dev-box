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
        cp -r /home/abc/* /home/$name/
        usermod -aG sudo $name
  done
}


add_users &

/etc/init.d/xrdp start

# Start SSH
service ssh restart && bash

tail -f /dev/null
