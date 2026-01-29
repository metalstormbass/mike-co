FROM cgr.dev/mikeco.com/python:3.11-dev
USER root
WORKDIR /app

COPY requirements-cpu.txt .
RUN pip install --no-cache-dir -r requirements-cpu.txt \
    && rm -rf /root/.cache/pip

COPY src/ ./src/

EXPOSE 8000

CMD ["-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
