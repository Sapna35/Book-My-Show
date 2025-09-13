# Use official Node.js 18 LTS image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install dependencies with legacy peer deps
RUN npm install --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the app
RUN npm run build

# Expose app port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
