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

# Run Jupyter Hub if it is enabled
if [ "$JUPYTER" = "1" ]; then (jupyterhub --port=8080 &) ; fi


# # Run Airflow if it is enabled
if [ "$AIRFLOW" = "1" ]; then airflow db init; sleep 10; airflow users create --role Admin --username sporule --email sporule --firstname sporule --lastname sporule --password sporule;rm /root/airflow/airflow-scheduler.pid /root/airflow/airflow-webserver-monitor.pid; (airflow webserver -p 8081 -D &) ;sleep 5;(airflow scheduler -D &); fi

/etc/init.d/xrdp start

# Start SSH
service ssh restart && bash

tail -f /dev/null
