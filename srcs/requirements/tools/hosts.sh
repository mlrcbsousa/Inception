#!/bin/bash

function hosts_delete {
    # remove lines with 42.fr in hosts file
    sudo sed -i '/42.fr/d' /etc/hosts
}

function hosts_create {
    # get IP of nginx container
    NGINX_IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx`

    # delete any previous 42.fr hosts
    hosts_delete

    # add host mappings to hosts file
    sudo sed -i '1i'$NGINX_IP' msousa.42.fr' /etc/hosts
    sudo sed -i '1i'$NGINX_IP' www.msousa.42.fr' /etc/hosts
    sudo sed -i '1i'$NGINX_IP' https://www.msousa.42.fr' /etc/hosts
}

if [ $1 == "create" ]; then
    hosts_create
    echo "Hosts created successfully"
fi

if [ $1 == "delete" ]; then
    hosts_delete
    echo "Hosts deleted successfully"
fi
