#!/bin/bash
cd /home/ec2-user/cucibayargo
pm2 stop all || true
pm2 start dist/api.js --name "node-app"