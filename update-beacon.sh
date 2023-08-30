#!/bin/bash
# Script for updating beacon boot files and rootfs.
# RUN AS SUDO

systemctl stop tftpd-hpa
exportfs -ua
umount /srv/nfs/exports/beacon_root/
mount -o ro /home/espar/image-eris-beacon-eris-beacon-baseboard.ext4 /srv/nfs/exports/beacon_root/

exportfs -a
systemctl start tftpd-hpa
