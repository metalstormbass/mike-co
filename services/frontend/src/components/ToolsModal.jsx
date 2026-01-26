import { useState } from 'react'
import { X, Upload, Image, Archive, FileText, Wand2 } from 'lucide-react'

export default function ToolsModal({ isOpen, onClose }) {
  const [activeTab, setActiveTab] = useState('ocr')
  const [ocrResult, setOcrResult] = useState(null)
  const [extractResult, setExtractResult] = useState(null)
  const [processedImage, setProcessedImage] = useState(null)
  const [isProcessing, setIsProcessing] = useState(false)

  if (!isOpen) return null

  const handleOCR = async (e) => {
    const file = e.target.files[0]
    if (!file) return

    setIsProcessing(true)
    setOcrResult(null)

    try {
      const formData = new FormData()
      formData.append('image', file)

      const response = await fetch('/api/ocr', {
        method: 'POST',
        body: formData
      })

      if (response.ok) {
        const data = await response.json()
        setOcrResult(data)
      } else {
        const error = await response.json()
        setOcrResult({ error: error.error || 'OCR failed' })
      }
    } catch (error) {
      setOcrResult({ error: error.message })
    } finally {
      setIsProcessing(false)
    }
  }

  const handleExtract = async (e) => {
    const file = e.target.files[0]
    if (!file) return

    setIsProcessing(true)
    setExtractResult(null)

    try {
      const formData = new FormData()
      formData.append('archive', file)

      const response = await fetch('/api/extract', {
        method: 'POST',
        body: formData
      })

      if (response.ok) {
        const data = await response.json()
        setExtractResult(data)
      } else {
        const error = await response.json()
        setExtractResult({ error: error.error || 'Extraction failed' })
      }
    } catch (error) {
      setExtractResult({ error: error.message })
    } finally {
      setIsProcessing(false)
    }
  }

  const handleImageProcess = async (e) => {
    const file = e.target.files[0]
    if (!file) return

    setIsProcessing(true)
    setProcessedImage(null)

    try {
      const formData = new FormData()
      formData.append('image', file)
      formData.append('width', document.getElementById('img-width').value || '')
      formData.append('height', document.getElementById('img-height').value || '')
      formData.append('format', document.getElementById('img-format').value)
      formData.append('quality', document.getElementById('img-quality').value)

      const response = await fetch('/api/image/process', {
        method: 'POST',
        body: formData
      })

      if (response.ok) {
        const data = await response.json()
        setProcessedImage(data)
      } else {
        const error = await response.json()
        setProcessedImage({ error: error.error || 'Processing failed' })
      }
    } catch (error) {
      setProcessedImage({ error: error.message })
    } finally {
      setIsProcessing(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-dark-950/80 backdrop-blur-sm">
      <div className="bg-dark-900 rounded-2xl shadow-2xl w-full max-w-4xl max-h-[90vh] flex flex-col border border-dark-700/50">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-dark-700/50">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-purple-600 flex items-center justify-center">
              <Wand2 className="w-5 h-5 text-white" />
            </div>
            <div>
              <h2 className="text-xl font-semibold text-dark-50">Tools</h2>
              <p className="text-sm text-dark-400">OCR, Archive Extraction & Image Processing</p>
            </div>
          </div>
          <button
            onClick={onClose}
            className="p-2 hover:bg-dark-800 rounded-lg transition-colors text-dark-400 hover:text-dark-200"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Tabs */}
        <div className="flex gap-2 px-6 pt-4 border-b border-dark-700/50">
          <button
            onClick={() => setActiveTab('ocr')}
            className={`flex items-center gap-2 px-4 py-2 rounded-t-lg font-medium transition-colors
              ${activeTab === 'ocr'
                ? 'bg-dark-800 text-primary-400 border-b-2 border-primary-500'
                : 'text-dark-400 hover:text-dark-200 hover:bg-dark-800/50'}`}
          >
            <FileText className="w-4 h-4" />
            OCR
          </button>
          <button
            onClick={() => setActiveTab('extract')}
            className={`flex items-center gap-2 px-4 py-2 rounded-t-lg font-medium transition-colors
              ${activeTab === 'extract'
                ? 'bg-dark-800 text-primary-400 border-b-2 border-primary-500'
                : 'text-dark-400 hover:text-dark-200 hover:bg-dark-800/50'}`}
          >
            <Archive className="w-4 h-4" />
            Extract Archive
          </button>
          <button
            onClick={() => setActiveTab('image')}
            className={`flex items-center gap-2 px-4 py-2 rounded-t-lg font-medium transition-colors
              ${activeTab === 'image'
                ? 'bg-dark-800 text-primary-400 border-b-2 border-primary-500'
                : 'text-dark-400 hover:text-dark-200 hover:bg-dark-800/50'}`}
          >
            <Image className="w-4 h-4" />
            Process Image
          </button>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto p-6">
          {/* OCR Tab */}
          {activeTab === 'ocr' && (
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-dark-300 mb-2">
                  Upload Image for OCR
                </label>
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleOCR}
                  disabled={isProcessing}
                  className="block w-full text-sm text-dark-400
                    file:mr-4 file:py-2 file:px-4
                    file:rounded-lg file:border-0
                    file:text-sm file:font-semibold
                    file:bg-primary-600 file:text-white
                    hover:file:bg-primary-500
                    file:cursor-pointer cursor-pointer
                    disabled:opacity-50"
                />
              </div>

              {isProcessing && (
                <div className="text-center py-8">
                  <div className="inline-block w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
                  <p className="mt-2 text-dark-400">Processing image...</p>
                </div>
              )}

              {ocrResult && !isProcessing && (
                <div className="bg-dark-800 rounded-lg p-4 border border-dark-700">
                  {ocrResult.error ? (
                    <p className="text-red-400">{ocrResult.error}</p>
                  ) : (
                    <>
                      <div className="flex items-center justify-between mb-2">
                        <h3 className="font-medium text-dark-200">Extracted Text</h3>
                        <span className="text-xs text-dark-400">
                          Confidence: {(ocrResult.confidence || 0).toFixed(1)}%
                        </span>
                      </div>
                      <pre className="text-sm text-dark-300 whitespace-pre-wrap font-mono bg-dark-900 p-3 rounded">
                        {ocrResult.text}
                      </pre>
                    </>
                  )}
                </div>
              )}
            </div>
          )}

          {/* Extract Archive Tab */}
          {activeTab === 'extract' && (
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-dark-300 mb-2">
                  Upload Archive (.zip, .7z, .tar.gz)
                </label>
                <input
                  type="file"
                  accept=".zip,.7z,.tar,.tar.gz,.tgz"
                  onChange={handleExtract}
                  disabled={isProcessing}
                  className="block w-full text-sm text-dark-400
                    file:mr-4 file:py-2 file:px-4
                    file:rounded-lg file:border-0
                    file:text-sm file:font-semibold
                    file:bg-primary-600 file:text-white
                    hover:file:bg-primary-500
                    file:cursor-pointer cursor-pointer
                    disabled:opacity-50"
                />
              </div>

              {isProcessing && (
                <div className="text-center py-8">
                  <div className="inline-block w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
                  <p className="mt-2 text-dark-400">Extracting archive...</p>
                </div>
              )}

              {extractResult && !isProcessing && (
                <div className="bg-dark-800 rounded-lg p-4 border border-dark-700">
                  {extractResult.error ? (
                    <p className="text-red-400">{extractResult.error}</p>
                  ) : (
                    <>
                      <h3 className="font-medium text-dark-200 mb-2">
                        Extracted {extractResult.fileCount} files
                      </h3>
                      <div className="max-h-96 overflow-y-auto space-y-1">
                        {extractResult.files?.map((file, idx) => (
                          <div key={idx} className="flex items-center gap-2 text-sm py-1">
                            <span className="text-dark-500">{file.isDirectory ? '📁' : '📄'}</span>
                            <span className="text-dark-300 flex-1 truncate">{file.name}</span>
                            <span className="text-dark-500 text-xs">
                              {file.isDirectory ? 'DIR' : `${(file.size / 1024).toFixed(1)} KB`}
                            </span>
                          </div>
                        ))}
                      </div>
                    </>
                  )}
                </div>
              )}
            </div>
          )}

          {/* Process Image Tab */}
          {activeTab === 'image' && (
            <div className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-dark-300 mb-2">
                    Width (px)
                  </label>
                  <input
                    id="img-width"
                    type="number"
                    placeholder="Auto"
                    className="w-full px-3 py-2 bg-dark-800 border border-dark-700 rounded-lg text-dark-200 placeholder-dark-500 focus:outline-none focus:ring-2 focus:ring-primary-500"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-dark-300 mb-2">
                    Height (px)
                  </label>
                  <input
                    id="img-height"
                    type="number"
                    placeholder="Auto"
                    className="w-full px-3 py-2 bg-dark-800 border border-dark-700 rounded-lg text-dark-200 placeholder-dark-500 focus:outline-none focus:ring-2 focus:ring-primary-500"
                  />
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-dark-300 mb-2">
                    Format
                  </label>
                  <select
                    id="img-format"
                    defaultValue="jpeg"
                    className="w-full px-3 py-2 bg-dark-800 border border-dark-700 rounded-lg text-dark-200 focus:outline-none focus:ring-2 focus:ring-primary-500"
                  >
                    <option value="jpeg">JPEG</option>
                    <option value="png">PNG</option>
                    <option value="webp">WebP</option>
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-dark-300 mb-2">
                    Quality (1-100)
                  </label>
                  <input
                    id="img-quality"
                    type="number"
                    defaultValue="80"
                    min="1"
                    max="100"
                    className="w-full px-3 py-2 bg-dark-800 border border-dark-700 rounded-lg text-dark-200 focus:outline-none focus:ring-2 focus:ring-primary-500"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-dark-300 mb-2">
                  Upload Image
                </label>
                <input
                  type="file"
                  accept="image/*"
                  onChange={handleImageProcess}
                  disabled={isProcessing}
                  className="block w-full text-sm text-dark-400
                    file:mr-4 file:py-2 file:px-4
                    file:rounded-lg file:border-0
                    file:text-sm file:font-semibold
                    file:bg-primary-600 file:text-white
                    hover:file:bg-primary-500
                    file:cursor-pointer cursor-pointer
                    disabled:opacity-50"
                />
              </div>

              {isProcessing && (
                <div className="text-center py-8">
                  <div className="inline-block w-8 h-8 border-4 border-primary-500 border-t-transparent rounded-full animate-spin"></div>
                  <p className="mt-2 text-dark-400">Processing image...</p>
                </div>
              )}

              {processedImage && !isProcessing && (
                <div className="bg-dark-800 rounded-lg p-4 border border-dark-700">
                  {processedImage.error ? (
                    <p className="text-red-400">{processedImage.error}</p>
                  ) : (
                    <>
                      <h3 className="font-medium text-dark-200 mb-2">Processed Image</h3>
                      <div className="space-y-2">
                        <div className="text-xs text-dark-400 space-y-1">
                          <p>Dimensions: {processedImage.metadata?.width} x {processedImage.metadata?.height}px</p>
                          <p>Format: {processedImage.metadata?.format?.toUpperCase()}</p>
                          <p>Size: {(processedImage.metadata?.size / 1024).toFixed(1)} KB</p>
                        </div>
                        <img
                          src={processedImage.image}
                          alt="Processed"
                          className="max-w-full rounded-lg border border-dark-700"
                        />
                        <a
                          href={processedImage.image}
                          download={`processed-image.${processedImage.metadata?.format || 'jpg'}`}
                          className="inline-block px-4 py-2 bg-primary-600 hover:bg-primary-500 text-white rounded-lg text-sm font-medium transition-colors"
                        >
                          Download Image
                        </a>
                      </div>
                    </>
                  )}
                </div>
              )}
            </div>
          )}
        </div>
      </div>
    </div>
  )
}
