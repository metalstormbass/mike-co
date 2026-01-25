// Node.js API Gateway - Entry Point
// Handles chat API, document ingestion, and routing

const express = require('express');
const app = express();

const PORT = process.env.PORT || 3000;

app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'healthy' });
});

// TODO: Add routes
// - POST /api/chat - Chat with RAG
// - POST /api/documents - Upload documents
// - GET /api/documents - List documents
// - DELETE /api/documents/:id - Delete document

app.listen(PORT, () => {
  console.log(`API Gateway listening on port ${PORT}`);
});
