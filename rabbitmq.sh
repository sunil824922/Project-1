script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input Rabbitmq_appuser_password Missing
  exit 1
fi

func_print_head "setup erlang repositories"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head "install erlang"
yum install erlang -y &>>$log_file
func_stat_check $?

func_print_head "setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_stat_check $?

func_print_head "Install erlang & RabbitMQ server"
yum install rabbitmq-server -y &>>$log_file
func_stat_check $?

func_print_head "Start RabbitMQ server"
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
func_stat_check $?

func_print_head "Add application user in RabbitMQ"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_stat_check $?