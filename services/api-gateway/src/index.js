// Node.js API Gateway - Entry Point
// Handles chat API, document ingestion, and routing

const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;

// Service URLs from environment
const LLM_SERVICE_URL = process.env.LLM_SERVICE_URL || 'http://llm-service:8001';
const DOCUMENT_PROCESSOR_URL = process.env.DOCUMENT_PROCESSOR_URL || 'http://document-processor:8002';

app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

// Chat/Query endpoint - routes to LLM service
app.post('/chat', async (req, res) => {
  try {
    const { message, conversationId } = req.body;
    
    if (!message) {
      return res.status(400).json({ error: 'Message is required' });
    }

    // Forward to LLM service (convert conversationId to string if present)
    const response = await fetch(`${LLM_SERVICE_URL}/query`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        query: message,
        conversation_id: conversationId ? String(conversationId) : null,
        top_k: 5,
        min_score: 0.3
      })
    });

    if (!response.ok) {
      const error = await response.text();
      console.error('LLM service error:', error);
      return res.status(response.status).json({ error: 'Failed to get response' });
    }

    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('Chat error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Search endpoint - semantic search without response generation
app.post('/search', async (req, res) => {
  try {
    const { query, topK = 5, minScore = 0.3 } = req.body;
    
    if (!query) {
      return res.status(400).json({ error: 'Query is required' });
    }

    const response = await fetch(`${LLM_SERVICE_URL}/search`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        query,
        top_k: topK,
        min_score: minScore
      })
    });

    if (!response.ok) {
      const error = await response.text();
      return res.status(response.status).json({ error: 'Search failed' });
    }

    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.listen(PORT, () => {
  console.log(`API Gateway listening on port ${PORT}`);
});
