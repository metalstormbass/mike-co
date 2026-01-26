# Build stage
FROM cgr.dev/mikeco.com/node:20-dev AS builder
USER root
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source files
COPY index.html ./
COPY vite.config.js ./
COPY tailwind.config.js ./
COPY postcss.config.js ./
COPY public ./public
COPY src ./src

# Build the application
RUN npm run build

# Production stage
FROM cgr.dev/mikeco.com/nginx:latest

# Copy built assets from builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

CMD ["-g", "daemon off;"]
