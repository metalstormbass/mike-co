import { useState, useRef, useEffect, useCallback } from 'react'
import Sidebar from './components/Sidebar'
import ChatArea from './components/ChatArea'
import WelcomeScreen from './components/WelcomeScreen'
import UploadModal from './components/UploadModal'
import SettingsModal from './components/SettingsModal'
import ToolsModal from './components/ToolsModal'

// API base URL for document processor
const DOCUMENT_API = '/api/documents'

function App() {
  const [messages, setMessages] = useState([])
  const [isLoading, setIsLoading] = useState(false)
  const [sidebarOpen, setSidebarOpen] = useState(true)
  const [uploadModalOpen, setUploadModalOpen] = useState(false)
  const [settingsModalOpen, setSettingsModalOpen] = useState(false)
  const [toolsModalOpen, setToolsModalOpen] = useState(false)
  const [documents, setDocuments] = useState([])
  const [conversations, setConversations] = useState([
    { id: 1, title: 'New Conversation', date: new Date() }
  ])
  const [activeConversation, setActiveConversation] = useState(1)

  // Fetch documents from API
  const fetchDocuments = useCallback(async () => {
    try {
      const response = await fetch(DOCUMENT_API)
      if (response.ok) {
        const data = await response.json()
        setDocuments(data.documents.map(doc => ({
          id: doc.id,
          name: doc.filename,
          size: doc.file_size,
          type: doc.file_type,
          status: doc.status,
          chunkCount: doc.chunk_count,
          uploadedAt: new Date(doc.created_at),
          processedAt: doc.processed_at ? new Date(doc.processed_at) : null
        })))
      }
    } catch (error) {
      console.error('Failed to fetch documents:', error)
    }
  }, [])

  // Fetch documents on mount and set up polling
  useEffect(() => {
    fetchDocuments()
    
    // Poll for updates every 5 seconds (for processing status)
    const interval = setInterval(fetchDocuments, 5000)
    return () => clearInterval(interval)
  }, [fetchDocuments])

  const sendMessage = async (content) => {
    if (!content.trim()) return

    const userMessage = {
      id: Date.now(),
      role: 'user',
      content,
      timestamp: new Date()
    }

    setMessages(prev => [...prev, userMessage])
    setIsLoading(true)

    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ 
          message: content,
          conversationId: activeConversation 
        })
      })

      if (response.ok) {
        const data = await response.json()
        const assistantMessage = {
          id: Date.now() + 1,
          role: 'assistant',
          content: data.response || data.message || "I've processed your request.",
          sources: data.sources || [],
          timestamp: new Date()
        }
        setMessages(prev => [...prev, assistantMessage])
      } else {
        // Demo response when API is not fully implemented
        const demoResponse = {
          id: Date.now() + 1,
          role: 'assistant',
          content: `I understand you're asking about: "${content}"\n\nThis is a demo response from the RAG Knowledge Base. Once documents are uploaded and indexed, I'll be able to provide accurate answers based on your knowledge base.\n\n**Features available:**\n- 📄 Document upload & processing\n- 🔍 Semantic search\n- 💬 Conversational AI\n- 📚 Source citations`,
          sources: [],
          timestamp: new Date()
        }
        setMessages(prev => [...prev, demoResponse])
      }
    } catch (error) {
      console.error('Chat error:', error)
      const errorMessage = {
        id: Date.now() + 1,
        role: 'assistant',
        content: "I'm having trouble connecting to the backend services. Please ensure all services are running.",
        timestamp: new Date()
      }
      setMessages(prev => [...prev, errorMessage])
    } finally {
      setIsLoading(false)
    }
  }

  const handleUpload = async (files) => {
    setUploadModalOpen(false)

    // Upload each file to the document processor
    for (const file of files) {
      // Add placeholder document with uploading status
      const tempId = `temp-${Date.now()}-${Math.random()}`
      setDocuments(prev => [...prev, {
        id: tempId,
        name: file.name,
        size: file.size,
        type: file.type,
        status: 'uploading',
        uploadedAt: new Date()
      }])

      try {
        const formData = new FormData()
        formData.append('file', file)

        const response = await fetch(`${DOCUMENT_API}/upload`, {
          method: 'POST',
          body: formData
        })

        if (response.ok) {
          const result = await response.json()
          // Update the temp document with real data
          setDocuments(prev => prev.map(doc => 
            doc.id === tempId 
              ? {
                  id: result.document_id,
                  name: file.name,
                  size: file.size,
                  type: file.type,
                  status: result.status,
                  chunkCount: result.chunks_created,
                  uploadedAt: new Date()
                }
              : doc
          ))
        } else {
          // Mark as error
          const error = await response.json()
          setDocuments(prev => prev.map(doc => 
            doc.id === tempId 
              ? { ...doc, status: 'error', error: error.detail || 'Upload failed' }
              : doc
          ))
        }
      } catch (error) {
        console.error('Upload error:', error)
        setDocuments(prev => prev.map(doc => 
          doc.id === tempId 
            ? { ...doc, status: 'error', error: error.message }
            : doc
        ))
      }
    }
    
    // Refresh document list
    fetchDocuments()
  }

  const startNewConversation = () => {
    const newConv = {
      id: Date.now(),
      title: 'New Conversation',
      date: new Date()
    }
    setConversations(prev => [newConv, ...prev])
    setActiveConversation(newConv.id)
    setMessages([])
  }

  return (
    <div className="flex h-screen bg-dark-950 overflow-hidden">
      {/* Ambient background */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none">
        <div className="absolute -top-40 -right-40 w-80 h-80 bg-primary-500/10 rounded-full blur-3xl" />
        <div className="absolute top-1/2 -left-40 w-80 h-80 bg-purple-500/10 rounded-full blur-3xl" />
        <div className="absolute -bottom-40 right-1/3 w-80 h-80 bg-pink-500/10 rounded-full blur-3xl" />
      </div>

      {/* Sidebar */}
      <Sidebar
        isOpen={sidebarOpen}
        onToggle={() => setSidebarOpen(!sidebarOpen)}
        conversations={conversations}
        activeConversation={activeConversation}
        onSelectConversation={setActiveConversation}
        onNewConversation={startNewConversation}
        documents={documents}
        onUploadClick={() => setUploadModalOpen(true)}
        onToolsClick={() => setToolsModalOpen(true)}
        onSettingsClick={() => setSettingsModalOpen(true)}
      />

      {/* Main content */}
      <main className="flex-1 flex flex-col relative">
        {messages.length === 0 ? (
          <WelcomeScreen onSendMessage={sendMessage} />
        ) : (
          <ChatArea 
            messages={messages}
            isLoading={isLoading}
            onSendMessage={sendMessage}
            sidebarOpen={sidebarOpen}
            onToggleSidebar={() => setSidebarOpen(!sidebarOpen)}
          />
        )}
      </main>

      {/* Upload Modal */}
      <UploadModal 
        isOpen={uploadModalOpen}
        onClose={() => setUploadModalOpen(false)}
        onUpload={handleUpload}
      />

      {/* Settings Modal */}
      <SettingsModal
        isOpen={settingsModalOpen}
        onClose={() => setSettingsModalOpen(false)}
      />

      {/* Tools Modal */}
      <ToolsModal
        isOpen={toolsModalOpen}
        onClose={() => setToolsModalOpen(false)}
      />
    </div>
  )
}

export default App
