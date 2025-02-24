#!/bin/bash
#move to app 
sudo chown -R $USER:$USER /repo/app 
cd /repo/app
export DB_HOST=mongodb://new.db.private.ip:27017/posts 
#run npm install 
npm install 
pm2 delete app.js
pm2 start app.js