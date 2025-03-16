# Use lightweight Node.js image
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package.json package-lock.json ./

# Install dependencies (include devDependencies for build)
RUN npm install --omit=dev

# Install TypeScript globally
RUN npm install -g typescript

# Copy the rest of the app files
COPY . .

# Build TypeScript
RUN npm run build

# Expose port
EXPOSE 3000

# Set environment variable for Cloud Run
ENV PORT=3000

# Start application
CMD ["node", "dist/api.js"]
