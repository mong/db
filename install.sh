#!/bin/bash

### Install script for docker and db sever at ubuntu 20.04 (focal fossa)

# get vars and set env accordingly
echo
read -p 'Please type the db root password: ' db_root_password
echo
echo Setting up $db_root_password
echo
cat << EOF >> ~/.profile
export MYSQL_ROOT_PASSWORD=$db_root_password
EOF

echo
read -p 'Please type the name of the qmongr database (e.g. imongr): ' db_name
echo
echo Setting up $db_name
echo
cat << EOF >> ~/.profile
export IMONGR_DB_NAME=$db_name
EOF

echo
read -p 'Please type the user name of the qmongr database (e.g. imongr): ' user_name
echo
echo Setting up $user_name
echo
cat << EOF >> ~/.profile
export IMONGR_DB_USER=$user_name
EOF

echo
read -p 'Please type the password of the qmongr database user: ' user_pass
echo
echo Setting up password
echo
cat << EOF >> ~/.profile
export IMONGR_DB_PASS=$user_pass
EOF

# upadate system
sudo apt update

# prerequisites for https apt
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# get GPG key for docker repost
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add apt source
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# update package database
sudo apt update

# use docker repo rather than ubuntu
apt-cache policy docker-ce

# install docker
sudo apt install -y docker-ce

# add this user to docker group
sudo usermod -aG docker ${USER}

# install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# provide right mode to binary
sudo chmod +x /usr/local/bin/docker-compose

# prepare use of awslogs from docker-compose (keys and secrets to be added manually)
sudo mkdir -p /etc/systemd/system/docker.service.d/
cat <<EOF > awslogs.conf
[Service]
Environment=
EOF
sudo mv awslogs.conf /etc/systemd/system/docker.service.d/

# (re)start dockerd
sudo systemctl daemon-reload
sudo systemctl restart docker

# install mariadb client
sudo apt install mariadb-client-core-10.3

# Make crontab entry for dumping qmongr db every night at 0100
echo
echo Setting up cron job for db dump
echo
crontab -l > current
echo "0 1 * * * $HOME/db/dump_imongr_db.sh >/dev/null 2>&1" >> current
crontab current
rm current

current=`crontab -l`
echo
echo Now, current crontab is:
echo
echo "$current"
echo
echo
echo Finished
echo
echo Please remember to add aws key/secrets to /etc/systemd/system/docker.service.d/awslogs.conf and re-login before running docker-compose
echo

