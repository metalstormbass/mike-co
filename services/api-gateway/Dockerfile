FROM node:20-bookworm-slim

WORKDIR /app

COPY package*.json ./
RUN npm install --only=production

COPY src/ ./src/

EXPOSE 3000

USER node

CMD ["npm", "start"]
