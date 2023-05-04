app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[34m>>>>>>>>>>$1<<<<<<<<<<\e[0m"
}
func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then

  print_head "copy Mongo.repo file"
  cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

  print_head "Install MongoD"
  yum install mongodb-org-shell -y

  print_head "LOad schema"
  mongo --host mongodb-dev.devops2023sk.online </app/schema/${component}.js

  fi
  if [ "${schema_setup}" ==  "mysql" ]; then
  func_print_head "install Mysql"
  yum install mysql -y

  func_print_head "download schema"
  mysql -h mysql-dev.devops2023sk.online -uroot -p$(mysql_root_password) < /app/schema/${component}.sql
  fi
 }

func_app_prereq() {
  func_print_head "Add application user"
  useradd ${app_user}

  func_print_head "Create application directory"
  rm -rf /app
  mkdir /app

  func_print_head "Download application content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  func_print_head "Extract application conetent"
  unzip /tmp/${component}.zip
}

func_systemd_setup() {
  func_print_head "setup systemd service"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service

  func_print_head "start the ${component} service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}


}

func_nodejs() {
func_print_head "Configiure Nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

func_print_head "Install Nodejs"
yum install nodejs -y

func_app_prereq

func_print_head "Install Nodejs dependencies"
npm install

func_schema_setup

func_systemd_setup

}

func_java() {
func_print_head "Install maven"
yum install maven -y

func_app_prereq

func_print_head "Download maven dependencies"
mvn clean package
mv target/${component}-1.0.jar ${component}.jar

func_schema_setup

func_systemd_setup


}


