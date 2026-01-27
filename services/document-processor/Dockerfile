FROM cgr.dev/mikeco.com/python:3.11-dev
USER root
WORKDIR /app

# Install system dependencies for document parsing
RUN apk add --no-cache \
    libmagic 

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt \
    && rm -rf /root/.cache/pip

COPY src/ ./src/

EXPOSE 8002

CMD ["-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8002"]
