#!/bin/bash

pwd
echo "app_start"
sudo chmod -R 777 /home/ec2-user/nodejs-app
cd /home/ec2-user/nodejs-app

#add npm and node to path
export NVM_DIR="$HOME/.nvm"	
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm	
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion (node is in path now)


npm i 
pm2 start index.js --name "my-api"
pm2 restart all

# npm install pm2 -g
# pm2 start index.js