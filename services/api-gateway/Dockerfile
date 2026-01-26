FROM node:20-bookworm-slim

WORKDIR /app

# Install security updates, OCR dependencies, archive tools, Git, and image processing libraries
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    tesseract-ocr \
    tesseract-ocr-eng \
    libtesseract-dev \
    unzip \
    p7zip-full \
    tar \
    gzip \
    bzip2 \
    git \
    libvips-dev \
    && rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm install --only=production

COPY src/ ./src/

EXPOSE 3000

USER node

CMD ["npm", "start"]
