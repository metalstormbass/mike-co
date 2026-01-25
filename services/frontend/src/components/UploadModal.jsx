import { useState, useCallback } from 'react'
import { X, Upload, FileText, File, CheckCircle, AlertCircle, Loader2 } from 'lucide-react'

export default function UploadModal({ isOpen, onClose, onUpload }) {
  const [files, setFiles] = useState([])
  const [isDragging, setIsDragging] = useState(false)
  const [uploading, setUploading] = useState(false)

  const handleDragOver = useCallback((e) => {
    e.preventDefault()
    setIsDragging(true)
  }, [])

  const handleDragLeave = useCallback((e) => {
    e.preventDefault()
    setIsDragging(false)
  }, [])

  const handleDrop = useCallback((e) => {
    e.preventDefault()
    setIsDragging(false)
    const droppedFiles = Array.from(e.dataTransfer.files)
    addFiles(droppedFiles)
  }, [])

  const handleFileSelect = (e) => {
    const selectedFiles = Array.from(e.target.files)
    addFiles(selectedFiles)
  }

  const addFiles = (newFiles) => {
    const validFiles = newFiles.filter(file => {
      const validTypes = ['application/pdf', 'text/plain', 'text/markdown', 
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'application/msword']
      return validTypes.includes(file.type) || 
        file.name.endsWith('.md') || 
        file.name.endsWith('.txt') ||
        file.name.endsWith('.pdf') ||
        file.name.endsWith('.docx')
    })
    
    setFiles(prev => [...prev, ...validFiles.map(f => ({
      file: f,
      id: Math.random().toString(36).substr(2, 9),
      status: 'pending'
    }))])
  }

  const removeFile = (id) => {
    setFiles(prev => prev.filter(f => f.id !== id))
  }

  const handleUpload = async () => {
    if (files.length === 0) return
    
    setUploading(true)
    
    // Mark all as uploading
    setFiles(prev => prev.map(f => ({ ...f, status: 'uploading' })))
    
    // Simulate upload
    await new Promise(resolve => setTimeout(resolve, 1500))
    
    // Mark all as complete
    setFiles(prev => prev.map(f => ({ ...f, status: 'complete' })))
    
    // Call parent handler
    onUpload(files.map(f => f.file))
    
    setTimeout(() => {
      setFiles([])
      setUploading(false)
      onClose()
    }, 1000)
  }

  const formatFileSize = (bytes) => {
    if (bytes < 1024) return bytes + ' B'
    if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB'
    return (bytes / (1024 * 1024)).toFixed(1) + ' MB'
  }

  const getFileIcon = (file) => {
    if (file.name.endsWith('.pdf')) return '📄'
    if (file.name.endsWith('.docx') || file.name.endsWith('.doc')) return '📝'
    if (file.name.endsWith('.md')) return '📑'
    return '📃'
  }

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 bg-dark-950/80 backdrop-blur-sm"
        onClick={onClose}
      />

      {/* Modal */}
      <div className="relative w-full max-w-lg glass rounded-2xl shadow-2xl overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-dark-700/50">
          <div>
            <h2 className="text-xl font-semibold text-dark-50">Upload Documents</h2>
            <p className="text-sm text-dark-400 mt-1">Add files to your knowledge base</p>
          </div>
          <button
            onClick={onClose}
            className="p-2 rounded-lg hover:bg-dark-700/50 text-dark-400 hover:text-dark-200 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6 space-y-4">
          {/* Drop zone */}
          <div
            onDragOver={handleDragOver}
            onDragLeave={handleDragLeave}
            onDrop={handleDrop}
            className={`
              relative border-2 border-dashed rounded-xl p-8
              transition-all duration-200 text-center
              ${isDragging 
                ? 'border-primary-500 bg-primary-500/10' 
                : 'border-dark-600 hover:border-dark-500'}
            `}
          >
            <input
              type="file"
              multiple
              accept=".pdf,.txt,.md,.docx,.doc"
              onChange={handleFileSelect}
              className="absolute inset-0 w-full h-full opacity-0 cursor-pointer"
            />
            
            <div className="space-y-3">
              <div className="w-12 h-12 rounded-xl bg-dark-800 mx-auto flex items-center justify-center">
                <Upload className={`w-6 h-6 ${isDragging ? 'text-primary-400' : 'text-dark-400'}`} />
              </div>
              <div>
                <p className="text-dark-200 font-medium">
                  {isDragging ? 'Drop files here' : 'Drag & drop files here'}
                </p>
                <p className="text-sm text-dark-500 mt-1">
                  or click to browse
                </p>
              </div>
              <p className="text-xs text-dark-500">
                Supports PDF, DOCX, TXT, MD
              </p>
            </div>
          </div>

          {/* File list */}
          {files.length > 0 && (
            <div className="space-y-2 max-h-48 overflow-y-auto">
              {files.map(({ file, id, status }) => (
                <div 
                  key={id}
                  className="flex items-center gap-3 p-3 rounded-lg bg-dark-800/50"
                >
                  <span className="text-2xl">{getFileIcon(file)}</span>
                  <div className="flex-1 min-w-0">
                    <p className="text-sm text-dark-200 truncate">{file.name}</p>
                    <p className="text-xs text-dark-500">{formatFileSize(file.size)}</p>
                  </div>
                  {status === 'pending' && (
                    <button
                      onClick={() => removeFile(id)}
                      className="p-1.5 rounded-lg hover:bg-dark-700 text-dark-400 hover:text-red-400 transition-colors"
                    >
                      <X className="w-4 h-4" />
                    </button>
                  )}
                  {status === 'uploading' && (
                    <Loader2 className="w-5 h-5 text-primary-400 animate-spin" />
                  )}
                  {status === 'complete' && (
                    <CheckCircle className="w-5 h-5 text-green-400" />
                  )}
                </div>
              ))}
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="flex items-center justify-end gap-3 p-6 border-t border-dark-700/50">
          <button
            onClick={onClose}
            className="px-4 py-2 rounded-lg
              text-dark-300 hover:text-dark-100
              hover:bg-dark-700/50
              transition-colors"
          >
            Cancel
          </button>
          <button
            onClick={handleUpload}
            disabled={files.length === 0 || uploading}
            className="px-6 py-2 rounded-lg
              bg-gradient-to-r from-primary-600 to-primary-500
              hover:from-primary-500 hover:to-primary-400
              disabled:opacity-50 disabled:cursor-not-allowed
              text-white font-medium
              transition-all duration-200
              flex items-center gap-2"
          >
            {uploading ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                <span>Uploading...</span>
              </>
            ) : (
              <>
                <Upload className="w-4 h-4" />
                <span>Upload {files.length > 0 ? `(${files.length})` : ''}</span>
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  )
}
