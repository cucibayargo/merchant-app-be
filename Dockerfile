# Use lightweight Node.js image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Install build dependencies for bcrypt
RUN apk add --no-cache python3 make g++

# Copy package.json and package-lock.json first
COPY package.json package-lock.json ./

# Install dependencies (include devDependencies for build)
RUN npm install

# Install TypeScript globally
RUN npm install -g typescript

# Rebuild bcrypt inside the container
RUN npm rebuild bcrypt --build-from-source

# Copy the rest of the app files
COPY . .

# Build TypeScript
RUN npm run build

# Expose port
EXPOSE 3000

# Start application
CMD ["node", "dist/api.js"]
