#!/bin/bash

####
# Description: This is a helper script which creates AWS security groups based on Semaphore's IP list.
# It will read the IPs from `ips.txt` file (requires separate download of IPs). Also, if you wish to 
# manually set your VPC, please add VPC ID value as a parameter to the last command.
#
# Runs on: Standard and Docker platform (requires AWS CLI)
#
# Usage:
# Run the following commands on a machine with configured AWS CLI and access to firewall.
#
#    wget https://gist.githubusercontent.com/ervinb/ecab6ca35ec87ed0cadf/raw/ips.txt
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/aws-sec-group-from-ip-list.sh
#    bash aws-sec-group-from-ip-list.sh [optional-vpc-id]
#
# For example, the following will download the Semaphore's IP list and create AWS security groups 
# in non-default (user specified) VPC with ID vpc-123c4567:
#
#    wget https://gist.githubusercontent.com/ervinb/ecab6ca35ec87ed0cadf/raw/ips.txt
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/aws-sec-group-from-ip-list.sh
#    bash aws-sec-group-from-ip-list.sh vpc-123c4567
#
# Note: Script requires a configured AWS CLI and access to the firewall. If no VPC ID is given, the default
# VPC ID will be used. It may be run from Semaphore's SSH session.
####

set -e

ip_list="ips.txt"
aws_sec_group="semaphore-worker-security-group-"
aws_sec_group_limit=50

ips_count=$(cat $ip_list | wc -l)
let sec_groups_needed=($ips_count+$aws_sec_group_limit-1)/$aws_sec_group_limit;

start_line=1
finish_line=$aws_sec_group_limit

for (( j=1; j <= $sec_groups_needed; j++ )) do
  current_sec_group="${aws_sec_group}$j"

  echo "Creating and populating $current_sec_group"
   
   if [ -z $1 ]
   then
    # vpc-id is not supplied, use default vpc
    sec_group_id="$(aws ec2 create-security-group --group-name $current_sec_group --description 'Security group for Semaphore workers')"
   else
    # vpc-id is supplied, use the custom vpc-id
    sec_group_id="$(aws ec2 create-security-group --group-name $current_sec_group --vpc-id $1 --description 'Security group for Semaphore workers')"
   fi
   #sec_group_id="$(echo $sec_group_id | cut -d ':' -f 2 | cut -d \" -f 2)"
   sec_group_id="$(echo $sec_group_id | grep -o 'sg-\w*')"

   sed "${start_line},${finish_line}!d" $ip_list | while read ip; do
    aws ec2 authorize-security-group-ingress --group-id $sec_group_id --protocol -1 --port -1 --cidr $ip/32
   done

   start_line=$(( $finish_line+1 ))
   finish_line=$(( $finish_line+$aws_sec_group_limit ))
done
