#!/bin/sh

set -e
#set -xv

MyName=$(basename $0)

LeaseFile=/var/lib/kea/kea-leases4.csv.2
TmpFile=$(mktemp /tmp/${MyName}.XXXXXXXX)

# renew halfway through the lease
RenewFactor=2

NumRecsToShow=$(( $(tput lines) - 4 ))
test $1x = allx && NumRecsToShow=999999

# kea lease record format is in file:
#    src/lib/dhcpsrv/csv_lease_file4.h

tail -n +2 ${LeaseFile} | tail -n ${NumRecsToShow} > ${TmpFile}

PrintFormat="%-15s %-17s %7s %-15s %-15s %-15s %-17s %s\n"

printf "${PrintFormat}" "IPAddr" "HWAddr" "Lease" "Start" "Renew" "Expire" "Hostname" "State"

while IFS=, read IPAddr HWAddr ClientID LeaseLenSecs ExpireSecs SubnetID FQDNFwd FQDNRev HostName State
do          
		StartSecs=$((${ExpireSecs} - ${LeaseLenSecs}))
			RenewLenSecs=$((${LeaseLenSecs} / ${RenewFactor}))
				RenewSecs=$((${ExpireSecs} - ${RenewLenSecs}))
					StartDate=$(date -r ${StartSecs} +%Y%m%dT%H%M%S)
						RenewDate=$(date -r ${RenewSecs} +%Y%m%dT%H%M%S)
							ExpireDate=$(date -r ${ExpireSecs} +%Y%m%dT%H%M%S)
								HostName=${HostName:="."}
									printf "${PrintFormat}" \
											   ${IPAddr} ${HWAddr} ${LeaseLenSecs} ${StartDate} ${RenewDate} ${ExpireDate} ${HostName} ${State}
										   done < ${TmpFile}

										   test -e ${TmpFile} && rm ${TmpFile}

