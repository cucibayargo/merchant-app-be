#!/bin/bash
cd /var/www/html
pm2 stop all || true
pm2 start dist/api.js --name "node-app"