# Use Node.js 20 with Ubuntu as base
FROM node:20

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    make \
    g++ \
    gcc \
    libudev-dev \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy package files and fix-deps.js
COPY package*.json .npmrc fix-deps.js ./

# Install dependencies with proper flags and caching
RUN npm config set legacy-peer-deps true \
    && node fix-deps.js \
    && npm ci \
    && npm cache clean --force

# Copy the rest of the application
COPY . .

# Set environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=10000
ENV HOSTNAME=0.0.0.0

# Build the application
RUN npm run build

# Expose port 10000
EXPOSE 10000

# Start the production server
CMD ["npm", "run", "start"] 