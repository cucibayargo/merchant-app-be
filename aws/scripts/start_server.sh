#!/bin/bash
cd /home/ec2-user/cucibayargo
npm install --omit=dev  

# Stop any existing Node.js process on port 3000 (if running)
fuser -k 3000/tcp || true

# Start the Node.js app in the background
# nohup node dist/api.js > app.log 2>&1 &