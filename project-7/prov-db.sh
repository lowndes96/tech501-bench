#!bin/bash
#update and upgrade packages without asking for user input
sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y
#install mongo db 
sudo apt-get install gnupg curl 
# import gpg key 
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor
#create file list 
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
# reload package db 
sudo apt-get update
# Install MongoDB Community Server
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6
#start
sudo systemctl start mongod
#configure the bind ip 
sudo sed -i 's/^  bindIp: [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/  bindIp: 0.0.0.0/' /etc/mongod.conf 
# enabling mongod to start on boot, starts it
sudo systemctl enable mongod
sudo systemctl is-enabled mongod # checking it's enabled
#restart the mongo db service
sudo systemctl restart mongod 