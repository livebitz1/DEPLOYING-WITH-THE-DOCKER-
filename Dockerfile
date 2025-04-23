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

# First, copy only package files to leverage Docker cache
COPY package*.json .npmrc ./

# Install dependencies with proper flags and caching
RUN npm config set legacy-peer-deps true \
    && npm ci \
    && npm cache clean --force

# Copy fix-deps.js and run it
COPY fix-deps.js ./
RUN node fix-deps.js

# Copy the rest of the application
COPY . .

# Set environment variables
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0

# Set Node options for build and runtime
ENV NODE_OPTIONS="--max-old-space-size=4096"

# Build the application
RUN npm run build

# Remove development dependencies
RUN npm prune --production

# Expose port 3000
EXPOSE 3000

# Add healthcheck
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:3000/api/health || exit 1

# Start the production server with increased memory limit
CMD ["npm", "run", "start"] 