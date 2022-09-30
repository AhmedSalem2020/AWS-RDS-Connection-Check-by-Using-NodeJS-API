pwd
sudo su - ec2-user
cd nodejs-app/
npm i 
npm install pm2 -g
pm2 start index.js