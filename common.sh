app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[34m>>>>>>>>>>$1<<<<<<<<<<\e[0m"
}

func_status_check() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi
}
func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then

  print_head "copy Mongo.repo file"
  cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo
  func_stat_check $?

  print_head "Install MongoD"
  yum install mongodb-org-shell -y
  func_stat_check $?

  print_head "LOad schema"
  mongo --host mongodb-dev.devops2023sk.online </app/schema/${component}.js
  func_stat_check $?

  fi
  if [ "${schema_setup}" ==  "mysql" ]; then
  func_print_head "install Mysql"
  yum install mysql -y
  func_stat_check $?

  func_print_head "download schema"
  mysql -h mysql-dev.devops2023sk.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
  func_stat_check $?

  fi
 }

func_app_prereq() {
  func_print_head "Add application user"
  useradd ${app_user}
  func_stat_check $?

  func_print_head "Create application directory"
  rm -rf /app
  mkdir /app
  func_stat_check $?

  func_print_head "Download application content"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  func_stat_check $?

  func_print_head "Extract application conetent"
  unzip /tmp/${component}.zip
  func_stat_check $?
}

func_systemd_setup() {
  func_print_head "setup systemd service"
  cp $script_path/${component}.service /etc/systemd/system/${component}.service
  func_stat_check $?

  func_print_head "start the ${component} service"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
  func_stat_check $?

}

func_nodejs() {
func_print_head "Configiure Nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
func_stat_check $?

func_print_head "Install Nodejs"
yum install nodejs -y
func_stat_check $?

func_app_prereq
func_stat_check $?

func_print_head "Install Nodejs dependencies"
npm install
func_stat_check $?

func_schema_setup
func_stat_check $?

func_systemd_setup
func_stat_check $?
}

func_java() {
func_print_head "Install maven"
yum install maven -y
func_stat_check $?

func_app_prereq
func_stat_check $?

func_print_head "Download maven dependencies"
mvn clean package
mv target/${component}-1.0.jar ${component}.jar
func_stat_check $?

func_schema_setup
func_stat_check $?

func_systemd_setup
func_stat_check $?

}


