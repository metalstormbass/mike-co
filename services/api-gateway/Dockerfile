FROM cgr.dev/mikeco.com/node:20-dev
USER root
WORKDIR /app

COPY package*.json ./
RUN npm install --only=production

COPY src/ ./src/

EXPOSE 3000

USER node

CMD ["npm", "start"]
