"""
PyTorch Embedding Service - Entry Point
Generates embeddings for documents and queries using transformer models
"""

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from contextlib import asynccontextmanager
from transformers import AutoTokenizer, AutoModel
import torch
import torch.nn.functional as F
import os

# Global model reference
model = None
tokenizer = None

MODEL_NAME = os.getenv("MODEL_NAME", "sentence-transformers/all-MiniLM-L6-v2")


class EmbedRequest(BaseModel):
    text: str


class EmbedBatchRequest(BaseModel):
    texts: list[str]


class EmbedResponse(BaseModel):
    embedding: list[float]
    dimensions: int


class EmbedBatchResponse(BaseModel):
    embeddings: list[list[float]]
    dimensions: int
    count: int


def mean_pooling(model_output, attention_mask):
    """Mean pooling - take attention mask into account for correct averaging"""
    token_embeddings = model_output[0]
    input_mask_expanded = attention_mask.unsqueeze(-1).expand(token_embeddings.size()).float()
    return torch.sum(token_embeddings * input_mask_expanded, 1) / torch.clamp(input_mask_expanded.sum(1), min=1e-9)


def encode_texts(texts: list[str]) -> torch.Tensor:
    """Encode texts to embeddings using the loaded model"""
    # Tokenize
    encoded_input = tokenizer(texts, padding=True, truncation=True, max_length=512, return_tensors='pt')
    
    # Compute embeddings
    with torch.no_grad():
        model_output = model(**encoded_input)
    
    # Mean pooling
    embeddings = mean_pooling(model_output, encoded_input['attention_mask'])
    
    # Normalize
    embeddings = F.normalize(embeddings, p=2, dim=1)
    
    return embeddings


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Load model on startup, cleanup on shutdown"""
    global model, tokenizer
    print(f"Loading embedding model: {MODEL_NAME}")
    
    # Load tokenizer and model
    tokenizer = AutoTokenizer.from_pretrained(MODEL_NAME)
    model = AutoModel.from_pretrained(MODEL_NAME)
    model.eval()  # Set to evaluation mode
    
    # Get embedding dimension
    test_input = tokenizer("test", return_tensors='pt')
    with torch.no_grad():
        test_output = model(**test_input)
    dim = test_output.last_hidden_state.shape[-1]
    print(f"Model loaded successfully. Embedding dimension: {dim}")
    
    yield
    
    # Cleanup
    print("Shutting down embedding service...")
    del model, tokenizer


app = FastAPI(
    title="RAG Embedding Service",
    description="Generate embeddings for documents and queries",
    lifespan=lifespan
)


@app.get("/health")
async def health():
    return {
        "status": "healthy",
        "model": MODEL_NAME,
        "model_loaded": model is not None
    }


@app.post("/embed", response_model=EmbedResponse)
async def generate_embedding(request: EmbedRequest):
    """Generate embedding for input text"""
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    if not request.text.strip():
        raise HTTPException(status_code=400, detail="Text cannot be empty")
    
    # Generate embedding
    embeddings = encode_texts([request.text])
    embedding = embeddings[0].tolist()
    
    return EmbedResponse(
        embedding=embedding,
        dimensions=len(embedding)
    )


@app.post("/embed/batch", response_model=EmbedBatchResponse)
async def generate_embeddings_batch(request: EmbedBatchRequest):
    """Generate embeddings for multiple texts"""
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    if not request.texts:
        raise HTTPException(status_code=400, detail="Texts list cannot be empty")
    
    # Filter out empty strings
    valid_texts = [t for t in request.texts if t.strip()]
    if not valid_texts:
        raise HTTPException(status_code=400, detail="All texts are empty")
    
    # Generate embeddings in batch
    embeddings = encode_texts(valid_texts)
    
    return EmbedBatchResponse(
        embeddings=embeddings.tolist(),
        dimensions=embeddings.shape[1],
        count=len(valid_texts)
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
