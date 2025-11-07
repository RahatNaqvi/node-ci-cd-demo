# Use the official Node.js image
FROM node:18

# Set working directory inside container
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all files to container
COPY . .

# Expose the app port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
