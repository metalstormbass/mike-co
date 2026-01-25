FROM node:20-bookworm-slim

WORKDIR /app

# Install security updates
RUN apt-get update && apt-get upgrade -y && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install --only=production

COPY src/ ./src/

EXPOSE 3000

USER node

CMD ["npm", "start"]
