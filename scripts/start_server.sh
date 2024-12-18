#!/bin/bash
cd /home/ec2-user/cucibayargo

# Check if pm2 is installed
if ! command -v pm2 &> /dev/null; then
    echo "pm2 could not be found, installing it..."
    sudo npm install -g pm2
fi

pm2 stop all || true
pm2 start dist/api.js --name "node-app"