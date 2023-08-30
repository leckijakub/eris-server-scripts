#!/bin/bash

USB_PORT="1-1.1"
dhcp_leases="/var/lib/kea/kea-leases4.csv"
tmp_dhcp_leases="/tmp/leases4.csv"
cp ${dhcp_leases} ${tmp_dhcp_leases}.1
sudo kea-lfc -4 -c /etc/kea/kea-dhcp4.conf -p /tmp/kea-lfc -x ${tmp_dhcp_leases}.2 -i ${tmp_dhcp_leases}.1 -o /tmp/kea-lfc.output -f /tmp/kea-lfc.finish

addresses=$(cat ${tmp_dhcp_leases}.2 | cut -d',' -f 1 | tail -n +2 | sort)
attached=$(sudo usbip port | grep usbip://)

for addr in $addresses
do
    if [[ ${attached} == *"${addr}"* ]]
    then
        echo "Beacon ${addr} already attached."
        continue
    fi
    echo -n Attaching beacon from IP: "${addr}"...
    if sudo usbip attach -r "${addr}" -b ${USB_PORT} > /dev/null 2>&1
    then
        echo Done.
    else
        echo Failed.
    fi

done

sudo rm ${tmp_dhcp_leases}*
