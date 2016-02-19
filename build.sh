#!/bin/bash

if [ -z `which salt-minion` ]
then
    curl -o install_salt.sh -L https://bootstrap.saltstack.com
    sudo sh install_salt.sh -M -U -Z stable
    sudo pip install apache-libcloud
fi
sudo mkdir -p /srv/salt
sudo mkdir -p /srv/pillar
sudo mkdir -p /srv/formulas
sudo cp minion.conf /etc/salt/minion.d/minion.conf
