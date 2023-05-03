script=${realpath "$0"}
script_path=${dirname "$script"}
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

echo -e "\e[36m>>>>>>>>>>Install Python3<<<<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>>>Add application user<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>>>create app directory<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>>>Download app content<<<<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip


echo -e "\e[36m>>>>>>>>>>Extract files<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>>>Download dependencies<<<<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>>>system setupD service<<<<<<<<<<\e[0m"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" $script_path/payment.service
cp $script_path/payment.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>>>start payment<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
