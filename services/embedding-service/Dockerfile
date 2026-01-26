FROM cgr.dev/mikeco.com/pytorch:2.8-py3.11-cuda12.8-cudnn9-dev
USER root
WORKDIR /app


COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/

EXPOSE 8000

CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
