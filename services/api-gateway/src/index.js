// Node.js API Gateway - Entry Point
// Handles chat API, document ingestion, and routing

const express = require('express');
const multer = require('multer');
const { createWorker } = require('tesseract.js');
const decompress = require('decompress');
const AdmZip = require('adm-zip');
const sharp = require('sharp');
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

// OCR endpoint - extract text from images
app.post('/ocr', upload.single('image'), async (req, res) => {
  let worker;
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'Image file is required' });
    }

    const imagePath = req.file.path;

    // Create Tesseract worker
    worker = await createWorker('eng');

    // Perform OCR
    const { data } = await worker.recognize(imagePath);

    // Clean up uploaded file
    await fs.unlink(imagePath).catch(() => {});

    res.json({
      text: data.text,
      confidence: data.confidence
    });
  } catch (error) {
    console.error('OCR error:', error);
    if (req.file) {
      await fs.unlink(req.file.path).catch(() => {});
    }
    res.status(500).json({ error: 'OCR processing failed' });
  } finally {
    if (worker) {
      await worker.terminate();
    }
  }
});

// Archive extraction endpoint - extract zip/7z files
app.post('/extract', upload.single('archive'), async (req, res) => {
  let extractPath;
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'Archive file is required' });
    }

    const archivePath = req.file.path;
    extractPath = path.join(os.tmpdir(), `extract_${Date.now()}`);

    // Create extraction directory
    await fs.mkdir(extractPath, { recursive: true });

    // Determine archive type and extract
    const ext = path.extname(req.file.originalname).toLowerCase();
    let files = [];

    if (ext === '.zip') {
      const zip = new AdmZip(archivePath);
      zip.extractAllTo(extractPath, true);
      files = zip.getEntries().map(entry => ({
        name: entry.entryName,
        size: entry.header.size,
        isDirectory: entry.isDirectory
      }));
    } else {
      // Use decompress for other formats
      const extractedFiles = await decompress(archivePath, extractPath);
      files = extractedFiles.map(file => ({
        name: file.path,
        size: file.data.length,
        isDirectory: file.type === 'directory'
      }));
    }

    // Clean up
    await fs.unlink(archivePath).catch(() => {});
    await fs.rm(extractPath, { recursive: true, force: true }).catch(() => {});

    res.json({
      extracted: true,
      fileCount: files.length,
      files: files
    });
  } catch (error) {
    console.error('Extract error:', error);
    if (req.file) {
      await fs.unlink(req.file.path).catch(() => {});
    }
    if (extractPath) {
      await fs.rm(extractPath, { recursive: true, force: true }).catch(() => {});
    }
    res.status(500).json({ error: 'Archive extraction failed' });
  }
});

// Image processing endpoint - resize/optimize images
app.post('/image/process', upload.single('image'), async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'Image file is required' });
    }

    const { width, height, format = 'jpeg', quality = 80 } = req.body;
    const imagePath = req.file.path;
    const outputPath = `${imagePath}_processed.${format}`;

    // Process image with sharp
    let pipeline = sharp(imagePath);

    if (width || height) {
      pipeline = pipeline.resize(
        width ? parseInt(width) : null,
        height ? parseInt(height) : null,
        { fit: 'inside', withoutEnlargement: true }
      );
    }

    // Set format and quality
    if (format === 'jpeg') {
      pipeline = pipeline.jpeg({ quality: parseInt(quality) });
    } else if (format === 'png') {
      pipeline = pipeline.png({ quality: parseInt(quality) });
    } else if (format === 'webp') {
      pipeline = pipeline.webp({ quality: parseInt(quality) });
    }

    // Process and save
    await pipeline.toFile(outputPath);

    // Get metadata
    const metadata = await sharp(outputPath).metadata();
    const stats = await fs.stat(outputPath);

    // Read processed image
    const imageBuffer = await fs.readFile(outputPath);
    const base64Image = imageBuffer.toString('base64');

    // Clean up
    await fs.unlink(imagePath).catch(() => {});
    await fs.unlink(outputPath).catch(() => {});

    res.json({
      success: true,
      image: `data:image/${format};base64,${base64Image}`,
      metadata: {
        width: metadata.width,
        height: metadata.height,
        format: metadata.format,
        size: stats.size
      }
    });
  } catch (error) {
    console.error('Image processing error:', error);
    if (req.file) {
      await fs.unlink(req.file.path).catch(() => {});
    }
    res.status(500).json({ error: 'Image processing failed' });
  }
});

app.listen(PORT, () => {
  console.log(`API Gateway listening on port ${PORT}`);
});
