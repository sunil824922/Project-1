script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user

func_nodejs
echo -e "\e[36m>>>>>>>>>>copy Mongo.repo file<<<<<<<<<<\e[0m"
cp /home/centos/Project-1/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>>>Install MongoD<<<<<<<<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>>>>LOad schema<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.devops2023sk.online </app/schema/user.js