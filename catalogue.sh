echo -e "\e[36m>>>>>>>>>>Configiure Nodejs repos<<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>>>Install Nodejs<<<<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>>Add application user<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>Create application directory<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>Download app content<<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[36m>>>>>>>>>>Unzip catalogue<<<<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[36m>>>>>>>>>>Install Nodejs dependencies<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>>>Copy catalogue systemD file<<<<<<<<<\e[0m"
cp /root/Project-1/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[36m>>>>>>>>>>stsart catalogue service<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[36m>>>>>>>>>>copy Mongo.repo file<<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>Install MongoD<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>LOad schema<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.devops2023sk.online </app/schema/catalogue.js