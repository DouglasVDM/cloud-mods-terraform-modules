<<-EOF
    #!/bin/bash
    echo “install nginx”
    sudo apt install nginx -y
    sudo systemctl enable nginx
    cd /etc/nginx/sites-available
    echo “make a copy default config file”
    sudo cp default cloud-mods-website
    cd ~

    echo "install node"
    curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs
    
    echo "clone repo"    
    git clone https://github.com/DouglasVDM/cloud-mods-dev-app.git
    
    echo "change directory to frontend"
    cd /home/ubuntu/cloud-mods-dev-app/frontend
    echo "install dependencies"
    npm ci
    echo "run react build script"
    npm run build
    
    echo "change directory to backend"
    cd ..
    cd backend
    echo "install dependencies"
    npm i

    echo "install pm2"    
    sudo npm install pm2 -g
    pm2 start /home/ubuntu/cloud-mods-dev-app/backend/index.js --name web-app
    pm2 startup
    sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u ubuntu --hp /home/ubuntu
    pm2 save
    pm2 status

    EOF