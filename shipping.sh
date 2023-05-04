script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input MySQL Root Password Missing
  exit 1
fi

print_head "Install maven"
yum install maven -y

print_head 'Create app user'
useradd roboshop

print_head "create app user"
rm -rf /app
mkdir /app

print_head "Download APP content"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

print_head "Extract app content"
cd /app
unzip /tmp/shipping.zip

print_head "Download maven dependencies"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

print_head "install Mysql"
yum install mysql -y

print_head "download schema"
mysql -h mysql-dev.devops2023sk.online -uroot -p$(mysql_root_password) < /app/schema/shipping.sql

print_head "setup systemd service"
cp $script_path/shipping.service /etc/systemd/system/shipping.service

print_headre "start the shipping"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping