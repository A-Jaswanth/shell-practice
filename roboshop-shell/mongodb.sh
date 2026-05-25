#!/bin/bash
user=$(id -u)
if [ $user -ne 0 ];then
    echo "pls switch to root user"
    exit 1
fi

# mv mongo.repo /etc/yum.repos.d/mongo.repo




