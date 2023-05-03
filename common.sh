app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<\e[0m"
}

func_nodejs() {
func_print_head "Configiure Nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

func_print_head "Install Nodejs"
yum install nodejs -y

func_print_head "Add application user"
useradd ${app_user}

func_print_head  "Create application directory"
rm -rf /app
mkdir /app

func_print_head "Download app content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

func_print_head "Unzip user"
unzip /tmp/${component}.zip

func_print_head "Install Nodejs dependencies"
npm install

func_print_head "Copy usersystemD file"
cp $script_path/${component}.service /etc/systemd/system/${component}.service

func_print_head "restart service"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
}

