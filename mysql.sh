script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input mysql_root_password Missing
  exit 1
fi

func_print_head "Disable Mysql 8"
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head "Copy the mysql repo"
cp /home/centos/Project-1/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?

func_print_head "Install mysql"
yum install mysql-community-server -y &>>$log_file
func_stat_check $?

func_print_head "start mysql"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_stat_check $?

func_print_head "set root passwd"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file