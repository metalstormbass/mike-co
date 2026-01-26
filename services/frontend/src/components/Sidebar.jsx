import { useState } from 'react'
import {
  MessageSquarePlus,
  FileText,
  Upload,
  ChevronLeft,
  ChevronRight,
  Brain,
  Trash2,
  MoreHorizontal,
  Search,
  Settings,
  FolderOpen,
  Wand2
} from 'lucide-react'

export default function Sidebar({
  isOpen,
  onToggle,
  conversations,
  activeConversation,
  onSelectConversation,
  onNewConversation,
  documents,
  onUploadClick,
  onToolsClick,
  onSettingsClick
}) {
  const [activeTab, setActiveTab] = useState('chats')

  return (
    <>
      {/* Sidebar */}
      <aside className={`
        ${isOpen ? 'w-72' : 'w-0'} 
        transition-all duration-300 ease-in-out
        flex flex-col
        bg-dark-900/80 backdrop-blur-xl
        border-r border-dark-700/50
        relative z-20
        overflow-hidden
      `}>
        {/* Logo & Header */}
        <div className="p-4 border-b border-dark-700/50">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-primary-500 to-purple-600 flex items-center justify-center shadow-lg shadow-primary-500/20">
              <Brain className="w-6 h-6 text-white" />
            </div>
            <div>
              <h1 className="font-semibold text-dark-50">RAG Knowledge</h1>
              <p className="text-xs text-dark-400">AI-Powered Search</p>
            </div>
          </div>
        </div>

        {/* New Chat Button */}
        <div className="p-3">
          <button 
            onClick={onNewConversation}
            className="w-full flex items-center gap-3 px-4 py-3 rounded-xl
              bg-gradient-to-r from-primary-600 to-primary-500
              hover:from-primary-500 hover:to-primary-400
              text-white font-medium
              transition-all duration-200
              shadow-lg shadow-primary-500/20
              hover:shadow-primary-500/30
              hover:scale-[1.02]
              active:scale-[0.98]"
          >
            <MessageSquarePlus className="w-5 h-5" />
            <span>New Conversation</span>
          </button>
        </div>

        {/* Tabs */}
        <div className="flex px-3 gap-1">
          <button
            onClick={() => setActiveTab('chats')}
            className={`flex-1 py-2 px-3 text-sm font-medium rounded-lg transition-colors
              ${activeTab === 'chats' 
                ? 'bg-dark-700/50 text-dark-50' 
                : 'text-dark-400 hover:text-dark-200 hover:bg-dark-800/50'}`}
          >
            Chats
          </button>
          <button
            onClick={() => setActiveTab('documents')}
            className={`flex-1 py-2 px-3 text-sm font-medium rounded-lg transition-colors
              ${activeTab === 'documents' 
                ? 'bg-dark-700/50 text-dark-50' 
                : 'text-dark-400 hover:text-dark-200 hover:bg-dark-800/50'}`}
          >
            Documents
          </button>
        </div>

        {/* Content */}
        <div className="flex-1 overflow-y-auto p-3 space-y-1">
          {activeTab === 'chats' ? (
            <>
              {conversations.map(conv => (
                <button
                  key={conv.id}
                  onClick={() => onSelectConversation(conv.id)}
                  className={`w-full flex items-center gap-3 px-3 py-2.5 rounded-lg
                    transition-all duration-150 group
                    ${activeConversation === conv.id 
                      ? 'bg-dark-700/70 text-dark-50' 
                      : 'hover:bg-dark-800/50 text-dark-300'}`}
                >
                  <MessageSquarePlus className="w-4 h-4 flex-shrink-0" />
                  <span className="flex-1 text-left text-sm truncate">{conv.title}</span>
                  <button className="opacity-0 group-hover:opacity-100 p-1 hover:bg-dark-600 rounded transition-all">
                    <MoreHorizontal className="w-4 h-4" />
                  </button>
                </button>
              ))}
            </>
          ) : (
            <>
              {/* Upload button */}
              <button 
                onClick={onUploadClick}
                className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg
                  border-2 border-dashed border-dark-600 hover:border-primary-500
                  text-dark-400 hover:text-primary-400
                  transition-all duration-200"
              >
                <Upload className="w-4 h-4" />
                <span className="text-sm">Upload Documents</span>
              </button>

              {/* Documents list */}
              {documents.length === 0 ? (
                <div className="text-center py-8 text-dark-500">
                  <FolderOpen className="w-12 h-12 mx-auto mb-3 opacity-50" />
                  <p className="text-sm">No documents yet</p>
                  <p className="text-xs mt-1">Upload files to get started</p>
                </div>
              ) : (
                documents.map(doc => (
                  <div
                    key={doc.id}
                    className="flex items-center gap-3 px-3 py-2.5 rounded-lg
                      bg-dark-800/30 hover:bg-dark-800/50
                      transition-all duration-150 group"
                  >
                    <FileText className={`w-4 h-4 flex-shrink-0 ${
                      doc.status === 'indexed' ? 'text-green-400' :
                      doc.status === 'error' ? 'text-red-400' :
                      'text-yellow-400'
                    }`} />
                    <div className="flex-1 min-w-0">
                      <p className="text-sm text-dark-200 truncate">{doc.name}</p>
                      <p className="text-xs text-dark-500">
                        {doc.status === 'uploading' && (
                          <span className="text-blue-400">⬆ Uploading...</span>
                        )}
                        {doc.status === 'processing' && (
                          <span className="text-yellow-400">⏳ Processing...</span>
                        )}
                        {doc.status === 'indexed' && (
                          <span className="text-green-400">✓ Indexed ({doc.chunkCount || 0} chunks)</span>
                        )}
                        {doc.status === 'error' && (
                          <span className="text-red-400">✗ Error</span>
                        )}
                        {doc.status === 'pending' && (
                          <span className="text-gray-400">◯ Pending</span>
                        )}
                      </p>
                    </div>
                    <button className="opacity-0 group-hover:opacity-100 p-1 hover:bg-dark-600 rounded transition-all">
                      <Trash2 className="w-4 h-4 text-dark-400 hover:text-red-400" />
                    </button>
                  </div>
                ))
              )}
            </>
          )}
        </div>

        {/* Footer */}
        <div className="p-3 border-t border-dark-700/50 space-y-1">
          <button
            onClick={onToolsClick}
            className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg
            text-dark-400 hover:text-dark-200 hover:bg-dark-800/50
            transition-all duration-150">
            <Wand2 className="w-4 h-4" />
            <span className="text-sm">Tools</span>
          </button>
          <button
            onClick={onSettingsClick}
            className="w-full flex items-center gap-3 px-3 py-2.5 rounded-lg
            text-dark-400 hover:text-dark-200 hover:bg-dark-800/50
            transition-all duration-150">
            <Settings className="w-4 h-4" />
            <span className="text-sm">Settings</span>
          </button>
        </div>
      </aside>

      {/* Toggle button */}
      <button
        onClick={onToggle}
        className={`absolute top-4 z-30 p-2 rounded-lg
          bg-dark-800/80 backdrop-blur border border-dark-700/50
          text-dark-400 hover:text-dark-200
          transition-all duration-300
          ${isOpen ? 'left-[276px]' : 'left-4'}`}
      >
        {isOpen ? <ChevronLeft className="w-4 h-4" /> : <ChevronRight className="w-4 h-4" />}
      </button>
    </>
  )
}
