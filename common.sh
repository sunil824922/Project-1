app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head() {
  echo -e "\e[35m>>>>>>>>>>$1<<<<<<<<<<\e[0m"
}

func_nodejs() {
print_head "Configiure Nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "Install Nodejs"
yum install nodejs -y

print_head "Add application user"
useradd ${app_user}

print_head  "Create application directory"
rm -rf /app
mkdir /app

print_head "Download app content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

print_head "Unzip user"
unzip /tmp/${component}.zip

print_head "Install Nodejs dependencies"
npm install

print_head "Copy usersystemD file"
cp $script_path/${component}.service /etc/systemd/system/${component}.service

print_head "restart service"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component}
}

