#!/bin/bash
cd /home/ec2-user/cucibayargo

# Check if pm2 is installed
if command -v pm2 &> /dev/null; then
    echo "pm2 is already installed at $(command -v pm2)"
    pm2 stop all || true
    pm2 restart all || true
fi

# /usr/local/bin/pm2 stop all || true
# /usr/local/bin/pm2 start dist/api.js --name "node-app"