#!/bin/bash

attached_ports=$(sudo usbip port | grep Port | cut -d " " -f 2 | cut -d ":" -f 1)

# echo $attached_ports

for port in $attached_ports
do
    echo -n "Detaching port ${port}..."
    if sudo usbip detach -p ${port} > /dev/null 2>&1
    then
        echo Done.
    else
        echo Failed.
    fi


done
