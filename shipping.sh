script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root-password= $1

echo -e "\e[36m>>>>>>>>>>Install maven<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>>>Create app user<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>create app user<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>Download APP content<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>>>Extract app content<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>>>Download maven dependencies<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>>install Mysql<<<<<<<<<<\e[0m"
yum install mysql -y

echo -e "\e[36m>>>>>>>>>>download schema<<<<<<<<<<\e[0m"
mysql -h mysql-dev.devops2023sk.online -uroot -p${mysql_root-password} < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>setup systemd service<<<<<<<<<<\e[0m"
cp $script_path/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>>restart the shipping<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping