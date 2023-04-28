echo -e "\e[36m>>>>>>>>>>Disable Mysql 8<<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>>>Copy the mysql repo<<<<<<<<<<\e[0m"
cp /home/centos/Project-1/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>>>Install mysql<<<<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>>>start mysql<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[36m>>>>>>>>>>set root passwd<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1