# Use official Node.js 18 LTS image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first (better build caching)
COPY package*.json ./

# Install dependencies with legacy peer deps to avoid conflicts
RUN npm install --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the app (optional, depends on your project type)
RUN npm run build

# Expose the application port
EXPOSE 3000

# Run the app
CMD ["npm", "start"]
