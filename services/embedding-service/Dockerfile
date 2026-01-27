FROM cgr.dev/mikeco.com/pytorch:2.8-py3.11-cuda12.8-cudnn9-dev
USER root
WORKDIR /app

# Install system dependencies and Python packages, then clean up

COPY requirements-cpu.txt .
RUN pip install --no-cache-dir -r requirements-cpu.txt

COPY src/ ./src/

EXPOSE 8000

CMD ["-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
