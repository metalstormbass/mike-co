import { useState } from 'react'
import { 
  Brain, 
  Search, 
  FileText, 
  Sparkles, 
  ArrowRight,
  BookOpen,
  MessageSquare,
  Zap
} from 'lucide-react'

const suggestions = [
  "What documents do I have in the knowledge base?",
  "Summarize the main topics covered in my documents",
  "Find information about...",
  "Compare different approaches mentioned in..."
]

const features = [
  {
    icon: Search,
    title: "Semantic Search",
    description: "Find relevant information using natural language"
  },
  {
    icon: Brain,
    title: "AI-Powered",
    description: "Powered by state-of-the-art language models"
  },
  {
    icon: FileText,
    title: "Multi-Format",
    description: "Support for PDF, DOCX, TXT, and more"
  },
  {
    icon: Zap,
    title: "Real-time",
    description: "Instant answers with source citations"
  }
]

export default function WelcomeScreen({ onSendMessage }) {
  const [input, setInput] = useState('')

  const handleSubmit = (e) => {
    e.preventDefault()
    if (input.trim()) {
      onSendMessage(input)
      setInput('')
    }
  }

  const handleSuggestion = (suggestion) => {
    onSendMessage(suggestion)
  }

  return (
    <div className="flex-1 flex flex-col items-center justify-center p-8 overflow-y-auto">
      <div className="max-w-3xl w-full space-y-12">
        {/* Hero */}
        <div className="text-center space-y-6">
          <div className="inline-flex items-center justify-center w-20 h-20 rounded-2xl 
            bg-gradient-to-br from-primary-500 via-purple-500 to-pink-500 
            shadow-2xl shadow-primary-500/30 animate-float">
            <Brain className="w-10 h-10 text-white" />
          </div>
          
          <div>
            <h1 className="text-4xl md:text-5xl font-bold mb-4">
              <span className="gradient-text">RAG Knowledge Base</span>
            </h1>
            <p className="text-lg text-dark-400 max-w-xl mx-auto">
              Ask questions about your documents and get intelligent, contextual answers 
              powered by advanced AI.
            </p>
          </div>
        </div>

        {/* Search input */}
        <form onSubmit={handleSubmit} className="relative">
          <div className="glass rounded-2xl p-2 glow">
            <div className="flex items-center gap-3">
              <div className="flex-1 relative">
                <Sparkles className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-primary-400" />
                <input
                  type="text"
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  placeholder="Ask anything about your knowledge base..."
                  className="w-full pl-12 pr-4 py-4 bg-transparent 
                    text-dark-100 placeholder-dark-500
                    focus:outline-none text-lg"
                />
              </div>
              <button
                type="submit"
                disabled={!input.trim()}
                className="px-6 py-4 rounded-xl
                  bg-gradient-to-r from-primary-600 to-primary-500
                  hover:from-primary-500 hover:to-primary-400
                  disabled:opacity-50 disabled:cursor-not-allowed
                  text-white font-medium
                  transition-all duration-200
                  flex items-center gap-2
                  shadow-lg shadow-primary-500/20"
              >
                <span>Search</span>
                <ArrowRight className="w-4 h-4" />
              </button>
            </div>
          </div>
        </form>

        {/* Suggestions */}
        <div className="space-y-3">
          <p className="text-sm text-dark-500 text-center">Try asking:</p>
          <div className="flex flex-wrap justify-center gap-2">
            {suggestions.map((suggestion, i) => (
              <button
                key={i}
                onClick={() => handleSuggestion(suggestion)}
                className="px-4 py-2 rounded-full
                  bg-dark-800/50 hover:bg-dark-700/50
                  border border-dark-700/50 hover:border-primary-500/50
                  text-sm text-dark-300 hover:text-dark-100
                  transition-all duration-200"
              >
                {suggestion}
              </button>
            ))}
          </div>
        </div>

        {/* Features grid */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
          {features.map((feature, i) => (
            <div 
              key={i}
              className="glass rounded-xl p-4 text-center
                hover:border-primary-500/30 transition-all duration-300
                group"
            >
              <div className="w-10 h-10 rounded-lg mx-auto mb-3
                bg-dark-800 group-hover:bg-primary-500/20
                flex items-center justify-center
                transition-colors duration-300">
                <feature.icon className="w-5 h-5 text-primary-400" />
              </div>
              <h3 className="font-medium text-dark-200 mb-1">{feature.title}</h3>
              <p className="text-xs text-dark-500">{feature.description}</p>
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}
