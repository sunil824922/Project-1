echo -e "\e[36m>>>>>>>>>>Install maven<<<<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>>>create app user<<<<<<<<<<\e[0m"
mkdir /app

echo -e "\e[36m>>>>>>>>>>Download APP content<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>>>Extract app content<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>>>Download maven dependencies<<<<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>>>copy the content<<<<<<<<<<\e[0m"
cp /home/centos/Project-1/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>>>install Mysql<<<<<<<<<<\e[0m"
yum install mysql -y
mysql -h mysql-dev.devops2023sk.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>>>restart the shipping<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping