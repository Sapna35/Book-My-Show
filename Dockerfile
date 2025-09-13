# Use Node.js LTS version
FROM node:20

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Clean npm cache (optional, avoids old cache issues)
RUN npm cache clean --force

# Install dependencies with legacy peer deps
RUN npm install --legacy-peer-deps

# Copy the rest of the app
COPY . .

# Build the React app (if it’s a React app)
RUN npm run build

# Expose port 3000
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
