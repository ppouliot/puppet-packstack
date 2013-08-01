#!/bin/bash
for HOST in $NETWORK_HOST $KVM_COMPUTE_HOST
do
    ssh -o StrictHostKeychecking=no $HOST "yum install -y centos-release-xen && yum update -y --disablerepo=* --enablerepo=Xen4CentOS kernel && reboot"
done


