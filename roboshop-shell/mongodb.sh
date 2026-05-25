#!/bin/bash
user=$(id -u)
if [ $user -ne 0 ];then
    echo "pls switch to root user"
    exit 1
fi
validate(){
    if [ $1 -ne 0 ]; then
        echo "$2 failure"
        exit 1
    else
        echo "$2 success"
    fi
}
cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "repo status is"

dnf install mongodb-org -y 
validate $? "mongodb install status is"

systemctl enable mongod 
validate $? "enable status is"

systemctl start mongod 
validate $? "start status is"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
validate $? "substituted status is"

systemctl restart mongod
validate $? "restart status is"

