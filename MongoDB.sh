cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
systemctl enable mongod
systemctl start mongod
## Server Ip need to change 129.0.0.0 to 0.0.0.0
systemctl restart mongod
