script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

exit

yum install nginx -y

echo -e "\e[36m>>>>>>>>>>copy roboshop.comf file<<<<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>>>removing html files<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>>>download frontend<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>>>chnage dirctory<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html

echo -e "\e[36m>>>>>>>>>>Unzip frontend<<<<<<<<<<\e[0m"
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>>>start nginx<<<<<<<<<<\e[0m"
systemctl restart nginx
systemctl enable nginx
systemctl status 
