# Use Node.js LTS image
FROM node:18-alpine

# Create app directory
WORKDIR /usr/src/app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy source code
COPY . .

# Build and expose port
RUN npm run build
EXPOSE 3000

# Run the app
CMD ["npm", "run", "start:prod"]
