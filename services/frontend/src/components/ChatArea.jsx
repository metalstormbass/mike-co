import { useState, useRef, useEffect } from 'react'
import { 
  Send, 
  User, 
  Bot, 
  Copy, 
  Check, 
  RefreshCw,
  Menu,
  Sparkles,
  FileText,
  ExternalLink
} from 'lucide-react'
import ReactMarkdown from 'react-markdown'

function Message({ message, isLast }) {
  const [copied, setCopied] = useState(false)
  const isUser = message.role === 'user'

  const handleCopy = () => {
    navigator.clipboard.writeText(message.content)
    setCopied(true)
    setTimeout(() => setCopied(false), 2000)
  }

  return (
    <div className={`flex gap-4 ${isUser ? 'flex-row-reverse' : ''}`}>
      {/* Avatar */}
      <div className={`flex-shrink-0 w-8 h-8 rounded-lg flex items-center justify-center
        ${isUser 
          ? 'bg-gradient-to-br from-purple-500 to-pink-500' 
          : 'bg-gradient-to-br from-primary-500 to-cyan-500'}`}>
        {isUser ? <User className="w-4 h-4 text-white" /> : <Bot className="w-4 h-4 text-white" />}
      </div>

      {/* Content */}
      <div className={`flex-1 max-w-[80%] space-y-2 ${isUser ? 'items-end' : ''}`}>
        <div className={`rounded-2xl px-4 py-3 
          ${isUser 
            ? 'bg-gradient-to-br from-purple-600/80 to-pink-600/80 text-white ml-auto' 
            : 'glass'}`}>
          {isUser ? (
            <p>{message.content}</p>
          ) : (
            <div className={`prose prose-invert max-w-none ${isLast ? 'typing-cursor' : ''}`}>
              <ReactMarkdown>{message.content}</ReactMarkdown>
            </div>
          )}
        </div>

        {/* Sources */}
        {!isUser && message.sources && message.sources.length > 0 && (
          <div className="flex flex-wrap gap-2 mt-2">
            {message.sources.map((source, i) => (
              <a
                key={i}
                href={source.url || '#'}
                className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg
                  bg-dark-800/50 hover:bg-dark-700/50
                  text-xs text-dark-300 hover:text-primary-400
                  border border-dark-700/50
                  transition-all duration-200"
              >
                <FileText className="w-3 h-3" />
                <span>{source.title || source.name || `Source ${i + 1}`}</span>
                <ExternalLink className="w-3 h-3" />
              </a>
            ))}
          </div>
        )}

        {/* Actions */}
        {!isUser && (
          <div className="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
            <button
              onClick={handleCopy}
              className="p-1.5 rounded-lg hover:bg-dark-700/50 text-dark-400 hover:text-dark-200 transition-colors"
              title="Copy"
            >
              {copied ? <Check className="w-4 h-4 text-green-400" /> : <Copy className="w-4 h-4" />}
            </button>
            <button
              className="p-1.5 rounded-lg hover:bg-dark-700/50 text-dark-400 hover:text-dark-200 transition-colors"
              title="Regenerate"
            >
              <RefreshCw className="w-4 h-4" />
            </button>
          </div>
        )}
      </div>
    </div>
  )
}

function LoadingMessage() {
  return (
    <div className="flex gap-4">
      <div className="flex-shrink-0 w-8 h-8 rounded-lg bg-gradient-to-br from-primary-500 to-cyan-500 flex items-center justify-center">
        <Bot className="w-4 h-4 text-white" />
      </div>
      <div className="glass rounded-2xl px-4 py-3">
        <div className="flex items-center gap-2">
          <div className="flex gap-1">
            <span className="w-2 h-2 rounded-full bg-primary-400 animate-bounce" style={{ animationDelay: '0ms' }} />
            <span className="w-2 h-2 rounded-full bg-primary-400 animate-bounce" style={{ animationDelay: '150ms' }} />
            <span className="w-2 h-2 rounded-full bg-primary-400 animate-bounce" style={{ animationDelay: '300ms' }} />
          </div>
          <span className="text-sm text-dark-400">Thinking...</span>
        </div>
      </div>
    </div>
  )
}

export default function ChatArea({ messages, isLoading, onSendMessage, sidebarOpen, onToggleSidebar }) {
  const [input, setInput] = useState('')
  const messagesEndRef = useRef(null)
  const textareaRef = useRef(null)

  useEffect(() => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }, [messages, isLoading])

  useEffect(() => {
    if (textareaRef.current) {
      textareaRef.current.style.height = 'auto'
      textareaRef.current.style.height = Math.min(textareaRef.current.scrollHeight, 200) + 'px'
    }
  }, [input])

  const handleSubmit = (e) => {
    e.preventDefault()
    if (input.trim() && !isLoading) {
      onSendMessage(input)
      setInput('')
    }
  }

  const handleKeyDown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
      e.preventDefault()
      handleSubmit(e)
    }
  }

  return (
    <div className="flex-1 flex flex-col h-full">
      {/* Header */}
      <header className="flex items-center gap-4 px-6 py-4 border-b border-dark-700/50 glass">
        {!sidebarOpen && (
          <button
            onClick={onToggleSidebar}
            className="p-2 rounded-lg hover:bg-dark-700/50 text-dark-400 hover:text-dark-200 transition-colors"
          >
            <Menu className="w-5 h-5" />
          </button>
        )}
        <div className="flex-1">
          <h2 className="font-semibold text-dark-100">Chat</h2>
          <p className="text-xs text-dark-500">{messages.length} messages</p>
        </div>
      </header>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-6 space-y-6">
        {messages.map((message, i) => (
          <div key={message.id} className="group">
            <Message message={message} isLast={i === messages.length - 1 && message.role === 'assistant'} />
          </div>
        ))}
        {isLoading && <LoadingMessage />}
        <div ref={messagesEndRef} />
      </div>

      {/* Input */}
      <div className="p-4 border-t border-dark-700/50">
        <form onSubmit={handleSubmit} className="max-w-4xl mx-auto">
          <div className="glass rounded-2xl p-2">
            <div className="flex items-end gap-3">
              <div className="flex-1 relative">
                <textarea
                  ref={textareaRef}
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  onKeyDown={handleKeyDown}
                  placeholder="Ask a question..."
                  rows={1}
                  className="w-full px-4 py-3 bg-transparent 
                    text-dark-100 placeholder-dark-500
                    focus:outline-none resize-none
                    max-h-[200px]"
                />
              </div>
              <button
                type="submit"
                disabled={!input.trim() || isLoading}
                className="p-3 rounded-xl
                  bg-gradient-to-r from-primary-600 to-primary-500
                  hover:from-primary-500 hover:to-primary-400
                  disabled:opacity-50 disabled:cursor-not-allowed
                  text-white
                  transition-all duration-200
                  shadow-lg shadow-primary-500/20
                  flex-shrink-0"
              >
                {isLoading ? (
                  <RefreshCw className="w-5 h-5 animate-spin" />
                ) : (
                  <Send className="w-5 h-5" />
                )}
              </button>
            </div>
          </div>
          <p className="text-xs text-dark-500 text-center mt-2">
            Press Enter to send, Shift+Enter for new line
          </p>
        </form>
      </div>
    </div>
  )
}
