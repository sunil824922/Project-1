script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[36m>>>>>>>>>>setup erlang repositories<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>install erlang<<<<<<<<<<\e[0m"
yum install erlang -y

echo -e "\e[36m>>>>>>>>>>setup RabbitMQ Repos<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>>>>Install erlang & RabbitMQ server<<<<<<<<<<\e[0m"
yum install rabbitmq-server -y

echo -e "\e[36m>>>>>>>>>>Start RabbitMQ server<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[36m>>>>>>>>>>Add application user in RabbitMQ<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
