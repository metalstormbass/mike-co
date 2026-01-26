// Node.js API Gateway - Entry Point
// Handles chat API, document ingestion, and routing

const express = require('express');
const multer = require('multer');
const fs = require('fs').promises;
const path = require('path');
const os = require('os');

const app = express();

const PORT = process.env.PORT || 3000;

// Service URLs from environment
const LLM_SERVICE_URL = process.env.LLM_SERVICE_URL || 'http://llm-service:8001';
const DOCUMENT_PROCESSOR_URL = process.env.DOCUMENT_PROCESSOR_URL || 'http://document-processor:8002';

// Configure multer for file uploads
const upload = multer({
  dest: os.tmpdir(),
  limits: { fileSize: 50 * 1024 * 1024 } // 50MB limit
});

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
        max_results: 5
      })
    });

    if (!response.ok) {
      throw new Error(`LLM service error: ${response.statusText}`);
    }

    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('Chat error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Document upload endpoint - routes to document processor
app.post('/documents', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'File is required' });
    }

    const formData = new FormData();
    const fileBuffer = await fs.readFile(req.file.path);
    const blob = new Blob([fileBuffer]);
    formData.append('file', blob, req.file.originalname);

    const response = await fetch(`${DOCUMENT_PROCESSOR_URL}/upload`, {
      method: 'POST',
      body: formData
    });

    // Clean up uploaded file
    await fs.unlink(req.file.path).catch(() => {});

    if (!response.ok) {
      throw new Error(`Document processor error: ${response.statusText}`);
    }

    const data = await response.json();
    res.json(data);
  } catch (error) {
    console.error('Upload error:', error);
    if (req.file) {
      await fs.unlink(req.file.path).catch(() => {});
    }
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Search documents endpoint
app.post('/search', async (req, res) => {
  try {
    const { query, limit = 5 } = req.body;

    if (!query) {
      return res.status(400).json({ error: 'Query is required' });
    }

    const response = await fetch(`${DOCUMENT_PROCESSOR_URL}/search`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query, limit })
    });

    if (!response.ok) {
      throw new Error(`Search error: ${response.statusText}`);
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
