import { useState, useRef, useEffect } from 'react'
import Sidebar from './components/Sidebar'
import ChatArea from './components/ChatArea'
import WelcomeScreen from './components/WelcomeScreen'
import UploadModal from './components/UploadModal'

function App() {
  const [messages, setMessages] = useState([])
  const [isLoading, setIsLoading] = useState(false)
  const [sidebarOpen, setSidebarOpen] = useState(true)
  const [uploadModalOpen, setUploadModalOpen] = useState(false)
  const [documents, setDocuments] = useState([])
  const [conversations, setConversations] = useState([
    { id: 1, title: 'New Conversation', date: new Date() }
  ])
  const [activeConversation, setActiveConversation] = useState(1)

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
    // Handle file upload
    const newDocs = files.map(file => ({
      id: Date.now() + Math.random(),
      name: file.name,
      size: file.size,
      type: file.type,
      status: 'processing',
      uploadedAt: new Date()
    }))
    
    setDocuments(prev => [...prev, ...newDocs])
    setUploadModalOpen(false)

    // Simulate processing
    setTimeout(() => {
      setDocuments(prev => prev.map(doc => 
        newDocs.find(n => n.id === doc.id) 
          ? { ...doc, status: 'indexed' }
          : doc
      ))
    }, 3000)
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
    </div>
  )
}

export default App
