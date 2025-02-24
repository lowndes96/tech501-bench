#!/bin/bash

# Define log file
LOG_FILE="/emily_custom_data.log"

# Redirect stdout and stderr to the log file
exec > >(sudo tee -a "$LOG_FILE") 2>&1

#upgrade and update all 
echo "fetching and upgrading packages..." 
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y

#needed installs 
echo "Installing nginx..."
sudo DEBIAN_FRONTEND=noninteractive apt install nginx -y 
sudo systemctl enable nginx 

echo "Download and install node.js v20..."
sudo DEBIAN_FRONTEND=noninteractive bash -c "curl -fsSL https://deb.nodesource.com/setup_20.x | bash -" && \
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs 

echo "checking nodejs and npm versions:" 
node -v
npm -v

echo "install of pm2 using npm..." 
sudo npm install -g pm2

# set up reverse proxy 
echo "setup reverse proxy..." 
sudo sed -i "s/try_files \$uri \$uri\/ =404/proxy_pass http:\/\/localhost:3000/g" /etc/nginx/sites-available/default
sudo nginx -t
sudo systemctl reload nginx 


#setup of db connection (remove as needed)
echo "setting uup db connection..." 
export DB_HOST=mongodb://10.0.3.35:27017/posts 

#accessing and running app 
echo "cloning app folder and accessing..." 
sudo git clone https://github.com/lowndes96/tech501-sparta-app-cicd.git /repo  
sudo chown -R $USER:$USER /repo/app  
cd /repo/app

echo "seeding the database..." 
npm install 

echo "stoping old instances of the app and starting again..." 
pm2 delete app.js
pm2 start app.js

echo "Script execution completed. Logs stored in $LOG_FILE" 