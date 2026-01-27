import { useState } from 'react'
import { Search, FileText, Loader2, AlertCircle } from 'lucide-react'

function SearchPanel() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])
  const [isSearching, setIsSearching] = useState(false)
  const [error, setError] = useState(null)
  const [searched, setSearched] = useState(false)

  const handleSearch = async (e) => {
    e.preventDefault()
    if (!query.trim()) return

    setIsSearching(true)
    setError(null)
    setSearched(true)

    try {
      const response = await fetch('/api/search', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          query: query.trim(),
          topK: 10,
          minScore: 0.2
        })
      })

      if (response.ok) {
        const data = await response.json()
        // API returns array directly, not {results: [...]}
        setResults(Array.isArray(data) ? data : [])
      } else {
        setError('Failed to search. Please try again.')
      }
    } catch (err) {
      console.error('Search error:', err)
      setError('Unable to connect to search service.')
    } finally {
      setIsSearching(false)
    }
  }

  return (
    <div className="flex-1 flex flex-col h-full overflow-hidden">
      {/* Search Header */}
      <div className="p-6 border-b border-dark-700/50">
        <div className="max-w-4xl mx-auto">
          <h2 className="text-2xl font-bold text-white mb-2 flex items-center gap-2">
            <Search className="w-6 h-6 text-primary-400" />
            Document Search
          </h2>
          <p className="text-dark-400 text-sm">
            Search your knowledge base using semantic similarity
          </p>
        </div>
      </div>

      {/* Search Bar */}
      <div className="p-6">
        <form onSubmit={handleSearch} className="max-w-4xl mx-auto">
          <div className="relative">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Search your documents..."
              className="w-full px-4 py-3 pl-12 rounded-xl
                bg-dark-800 border border-dark-700/50
                text-white placeholder-dark-400
                focus:outline-none focus:ring-2 focus:ring-primary-500/50
                transition-all"
              disabled={isSearching}
            />
            <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-dark-400" />
            {isSearching && (
              <Loader2 className="absolute right-4 top-1/2 -translate-y-1/2 w-5 h-5 text-primary-400 animate-spin" />
            )}
          </div>
          <button type="submit" className="hidden">Search</button>
        </form>

        {/* Error Message */}
        {error && (
          <div className="max-w-4xl mx-auto mt-4 p-4 rounded-xl bg-red-500/10 border border-red-500/30">
            <div className="flex items-center gap-2 text-red-400">
              <AlertCircle className="w-4 h-4" />
              <p className="text-sm">{error}</p>
            </div>
          </div>
        )}
      </div>

      {/* Results Area */}
      <div className="flex-1 overflow-y-auto px-6 pb-6">
        <div className="max-w-4xl mx-auto space-y-3">
          {!searched && (
            <div className="text-center py-12">
              <Search className="w-16 h-16 text-dark-600 mx-auto mb-4" />
              <p className="text-dark-400">
                Enter a query above to search your documents
              </p>
            </div>
          )}

          {searched && !isSearching && results.length === 0 && (
            <div className="text-center py-12">
              <FileText className="w-16 h-16 text-dark-600 mx-auto mb-4" />
              <p className="text-dark-400">No results found</p>
              <p className="text-dark-500 text-sm mt-2">
                Try rephrasing your query or uploading more documents
              </p>
            </div>
          )}

          {isSearching && (
            <div className="text-center py-12">
              <Loader2 className="w-12 h-12 text-primary-400 mx-auto mb-4 animate-spin" />
              <p className="text-dark-400">Searching...</p>
            </div>
          )}

          {results.map((result, index) => (
            <div
              key={index}
              className="glass rounded-xl p-4 border border-dark-700/30
                hover:border-primary-500/30 transition-all duration-200"
            >
              {/* Header */}
              <div className="flex items-start justify-between gap-4 mb-3">
                <div className="flex items-center gap-2 flex-1 min-w-0">
                  <FileText className="w-4 h-4 text-primary-400 flex-shrink-0" />
                  <span className="text-sm text-dark-300 truncate">
                    {result.filename || result.metadata?.filename || 'Unknown Document'}
                  </span>
                </div>
                {result.score && (
                  <div className="flex-shrink-0">
                    <div className="px-2.5 py-1 rounded-lg bg-primary-500/20 border border-primary-500/30">
                      <span className="text-xs font-semibold text-primary-300">
                        {Math.round(result.score * 100)}% match
                      </span>
                    </div>
                  </div>
                )}
              </div>

              {/* Content */}
              <div className="text-sm text-dark-200 leading-relaxed">
                <p className="line-clamp-4">
                  {result.content || result.text || 'No content available'}
                </p>
              </div>

              {/* Metadata */}
              {result.metadata && (
                <div className="mt-3 pt-3 border-t border-dark-700/30 flex flex-wrap gap-2 text-xs">
                  {result.metadata.file_type && (
                    <span className="px-2 py-1 rounded bg-dark-800/50 text-dark-400">
                      {result.metadata.file_type}
                    </span>
                  )}
                  {result.chunk_id && (
                    <span className="px-2 py-1 rounded bg-dark-800/50 text-dark-400">
                      Chunk {result.chunk_index || result.chunk_id.split('_').pop()}
                    </span>
                  )}
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  )
}

export default SearchPanel
