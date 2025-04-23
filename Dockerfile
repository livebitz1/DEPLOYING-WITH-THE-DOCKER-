# Use Node.js 20 as the base image
FROM node:20-alpine

# Install Python, build dependencies, and Linux kernel headers
RUN apk add --no-cache python3 make g++ gcc linux-headers

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY .npmrc ./

# Install dependencies with legacy peer deps
RUN npm install --legacy-peer-deps

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Set environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

# Expose port 3000
EXPOSE 3000

# Start the production server
CMD ["npm", "run", "start"] 