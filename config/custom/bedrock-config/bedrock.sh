#!/bin/bash
#Set Variables
site_name="vvv-bedrock"
db_name="vvv_br_db"
db_user="vvv_br_user"
db_pass="vvv_br_pw"
db_host="localhost"

#Make bedrock directory in www folder
if [[ ! -d /srv/www/$site_name ]]; then
	echo -e "Make new folder /srv/www/$site_name"
	mkdir /srv/www/$site_name
fi

#Create Composer project using online repo
echo -e "Creating new roots/bedrock Composer project under /srv/www/$site_name"
composer create-project -n roots/bedrock /srv/www/$site_name

echo -e "Setting up Bedrock SQL database and user."
SQLCMD="CREATE DATABASE IF NOT EXISTS \`$db_name\`; GRANT ALL PRIVILEGES ON \`$db_name\`.* TO '$db_user'@'$db_host' IDENTIFIED BY '$db_pass';"
mysql -u root -proot -e "$SQLCMD"

#Copy Nginx conf to Custom Sites Directory
echo -e "Adding Nginx conf file to /etc/nginx/custom-sites/$site_name.conf"
cp /srv/config/bedrock-config/files/vvv-bedrock.conf /etc/nginx/custom-sites/$site_name.conf
sed -i.bak "s/vvv-bedrock/$site_name/g" /etc/nginx/custom-sites/$site_name.conf

#edit existing .env file to replace vars
echo -e "Updating Bedrock .env file with new vars"
sed -i.bak "s/database_name/$db_name/g" /srv/www/vvv-bedrock/.env
sed -i.bak "s/database_user/$db_user/g" /srv/www/vvv-bedrock/.env
sed -i.bak "s/database_password/$db_pass/g" /srv/www/vvv-bedrock/.env
sed -i.bak "s/database_host/$db_host/g" /srv/www/vvv-bedrock/.env
sed -i.bak "s/example.com/$site_name/g" /srv/www/vvv-bedrock/.env
rm /srv/www/vvv-bedrock/.env.bak

#restart Nginx
service nginx restart
