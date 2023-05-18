script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh


func_print_head "Install nginx"
yum install nginx -y  &>>$log_file
func_stat_check $?

func_print_head "copy roboshop.comf file"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>$log_file
func_stat_check $?

func_print_head "removing html files"
rm -rf /usr/share/nginx/html/*  &>>$log_file
func_stat_check $?

func_print_head "download frontend"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip  &>>$log_file
func_stat_check $?

func_print_head "chnage dirctory"
cd /usr/share/nginx/html  &>>$log_file
func_stat_check $?

func_print_head "Unzip frontend"
unzip /tmp/frontend.zip  &>>$log_file
func_stat_check $?

func_print_head "start nginx"
systemctl enable nginx   &>>$log_file
systemctl restart nginx  &>>$log_file
systemctl status  &>>$log_file
func_stat_check $?