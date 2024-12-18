#!/bin/bash
cd /home/ec2-user/cucibayargo
pwd  # Check the current directory, to ensure you're in the correct location
npm install --omit=dev  # Install production dependencies only
