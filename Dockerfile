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
ENV NODE_ENV=development
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

# Start the development server
CMD ["npm", "run", "dev"] 