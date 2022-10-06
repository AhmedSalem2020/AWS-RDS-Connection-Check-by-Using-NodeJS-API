1      service codedeploy-agent status
    2  sudo service codedeploy-agent status
    3  cd nodejs-app/
    4                                  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
    5                                  . ~/.nvm/nvm.sh
    6                                  export NVM_DIR=\$HOME/.nvm
    7  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # loads nvm
    8                                  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # loads nvm bash_completion (node is in path now)
    9                                  nvm install 16.0.0
   10                                  nvm use --delete-prefix v16.0.0
   11                                  npm install pm2 -g
   12  pm2 start index.js --name "my-api"
   13  curl localhost:8080
   14  ls
   15  cat .env
   16  ls -a
   17  curl localhost:8080
   18  npm i aws-sdk
   19  npm start
   20  vim index.js
   21  npm start
   22  cd nodejs-app/
   23  npm start
   24  ls
   25  nvm -v
   26  node -v
   27                                  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
   28  nvm install 16.0.0
   29                                  nvm use --delete-prefix v16.0.0
   30                                  npm install pm2 -g
   31  npm start
   32  npm i
   33  npm start
   34  curl localhost:8080/live
   35  cd $HOME/.pm2/logs/
   36  ls
   37  tail my-api-error.log
   38  tail my-api-out.log
   39  cat my-api-out.log
   40  cd /home/ec2-user/nodejs-app/
   41  vim index.js
   42  pm2 stop
   43  pm2 stop all
   44  npm start
   45  ls
   46  vim .env
   47  npm start
   48  vim .env
   49  npm start
   50  pm2 start all
   51  npm start
   52  curl localhost:8080
   53  curl localhost:8080/live
   54  cd $HOME/.pm2/logs/
   55  ls
   56  tail my-api-error.log
   57  sudo lsof -i -P -n | grep LISTEN
   58  sudo netstat -tulpn | grep LISTEN
   59  pm2 list
   60  sudo ss -tulpn | grep LISTEN
   61  fuser -k 8080/tcp
   62  sudo ss -tulpn | grep LISTEN
   63  pm2 list
   64  pm2 restart all
   65  curl localhost:8080/live
   66  pm2 list
   67  cd $HOME/.pm2/logs/
   68  cat my-api-error.log
   69  cat my-api-out.log
   70  cd /home/ec2-user/nodejs-app/
   71  vi index.js
   72  pm restart all
   73  pm2 restart all
   74  npm start
   75  curl localhost:8080/live
   76  cd $HOME/.pm2/logs/
   77  cat my-api-error.log
   78  cat my-api-out.log
   79  pm index.js
   80  cd /home/ec2-user/nodejs-app/
   81  pm2 index.js
   82  pm2 start index.js --name "my-api"
   83  pm2 start index
   84  vim index.js
   85  pm2 list
   86  pm2 restart all
   87  vi index.js
   88  curl localhost:8080/live