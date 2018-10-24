#!/bin/bash

# Usage: bash aws-sec-group-from-ip-list.sh [<vpc-id>]
# If VPC ID is not supplied, the security groups will be added to the default VPC.

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
