#!/bin/bash
if [[ ! -f /etc/sysconfig/iptables ]]; then 
   echo "Error: file does not exist" 
   exit 1 
fi 

os_version=$(cat /etc/os-release | grep ^VERSION_ID | cut -d '=' -f2 | tr -d '\"')

if [[ "$os_version" == "7" ]]; then 
   exit 0
elif [[ "$os_version" == "8" ]]; then
  last_modified=$(stat -c %Y /etc/sysconfig/iptables) 
  current_time=$(date +%s)  

if (( current_time - last_modified > 3600 )); then 
current_hour=$(date +%H)
fi
if [[ "$current_hour" == "07" || "$current_hour" == "17" ]]; then 
cp /etc/sysconfig/iptables /etc/sysconfig/iptables.bak 
echo "Iptables configuration saved to /etc/sysconfig/iptables.bak" 
exit 0
else
echo "Current hour is not 7 or 17; skipping backup." 
exit 0
fi
else
echo "File was modified less than an hour ago; exiting without backup." 
exit 0
fi
if [[ $os_version != "7" || $os_version != "8" ]]; then
echo "Unsupported RHEL version: "$os_version"" 
exit 1
fi
