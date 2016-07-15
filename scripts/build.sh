#!/bin/bash

if [ -z `which salt-minion` ]
then
    curl -o install_salt.sh -L https://bootstrap.saltstack.com
    sudo sh install_salt.sh -M -U -Z -L -P -A 127.0.0.1 stable
fi
sudo mkdir -p /srv/salt
sudo mkdir -p /srv/pillar
