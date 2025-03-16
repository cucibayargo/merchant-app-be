# Use lightweight Node.js image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --omit=dev

# Rebuild bcrypt inside the container
RUN npm rebuild bcrypt --build-from-source

# Copy the rest of the app files
COPY . .

# Expose port
EXPOSE 3000

# Start application
CMD ["node", "dist/api.js"]
