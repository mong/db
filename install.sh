#!/bin/bash

### Install script for docker and db sever at ubuntu 18.04 (bionic)

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
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

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

# (re)start dockerd
sudo systemctl daemon-reload
sudo systemctl restart docker

# install mariadb client
sudo apt install mariadb-client-core-10.1

echo
echo Finished
echo
echo Please remember to re-login before running docker-compose
echo

