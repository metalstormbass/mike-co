import { useState, useEffect } from 'react'
import { X, Monitor, Moon, Sun, Type, Check } from 'lucide-react'

const FONT_SIZES = [
  { id: 'small', label: 'Small', value: '14px' },
  { id: 'medium', label: 'Medium', value: '16px' },
  { id: 'large', label: 'Large', value: '18px' },
]

const THEMES = [
  { id: 'dark', label: 'Dark', icon: Moon },
  { id: 'light', label: 'Light', icon: Sun },
  { id: 'system', label: 'System', icon: Monitor },
]

export default function SettingsModal({ isOpen, onClose }) {
  const [settings, setSettings] = useState({
    theme: 'dark',
    fontSize: 'medium',
  })

  // Load settings from localStorage on mount
  useEffect(() => {
    const saved = localStorage.getItem('rag-settings')
    if (saved) {
      try {
        setSettings(JSON.parse(saved))
      } catch (e) {
        console.error('Failed to parse settings:', e)
      }
    }
  }, [])

  // Apply settings when they change
  useEffect(() => {
    // Apply theme
    const root = document.documentElement
    if (settings.theme === 'system') {
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
      root.classList.toggle('light-mode', !prefersDark)
    } else {
      root.classList.toggle('light-mode', settings.theme === 'light')
    }

    // Apply font size
    const fontSizeConfig = FONT_SIZES.find(f => f.id === settings.fontSize)
    if (fontSizeConfig) {
      root.style.setProperty('--base-font-size', fontSizeConfig.value)
    }

    // Save to localStorage
    localStorage.setItem('rag-settings', JSON.stringify(settings))
  }, [settings])

  if (!isOpen) return null

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 bg-black/60 backdrop-blur-sm"
        onClick={onClose}
      />
      
      {/* Modal */}
      <div className="relative w-full max-w-md mx-4 bg-dark-800 rounded-2xl shadow-2xl border border-dark-700/50 overflow-hidden">
        {/* Header */}
        <div className="flex items-center justify-between px-6 py-4 border-b border-dark-700/50">
          <h2 className="text-lg font-semibold text-dark-50">Settings</h2>
          <button
            onClick={onClose}
            className="p-2 rounded-lg hover:bg-dark-700/50 text-dark-400 hover:text-dark-200 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6 space-y-6">
          {/* Theme Selection */}
          <div>
            <label className="block text-sm font-medium text-dark-200 mb-3">
              Theme
            </label>
            <div className="grid grid-cols-3 gap-2">
              {THEMES.map(theme => {
                const Icon = theme.icon
                const isActive = settings.theme === theme.id
                return (
                  <button
                    key={theme.id}
                    onClick={() => setSettings(s => ({ ...s, theme: theme.id }))}
                    className={`flex flex-col items-center gap-2 p-4 rounded-xl border-2 transition-all
                      ${isActive 
                        ? 'border-primary-500 bg-primary-500/10 text-primary-400' 
                        : 'border-dark-700 hover:border-dark-600 text-dark-400 hover:text-dark-200'
                      }`}
                  >
                    <Icon className="w-6 h-6" />
                    <span className="text-sm font-medium">{theme.label}</span>
                    {isActive && (
                      <Check className="w-4 h-4 absolute top-2 right-2" />
                    )}
                  </button>
                )
              })}
            </div>
          </div>

          {/* Font Size */}
          <div>
            <label className="block text-sm font-medium text-dark-200 mb-3">
              <Type className="w-4 h-4 inline mr-2" />
              Font Size
            </label>
            <div className="flex gap-2">
              {FONT_SIZES.map(size => {
                const isActive = settings.fontSize === size.id
                return (
                  <button
                    key={size.id}
                    onClick={() => setSettings(s => ({ ...s, fontSize: size.id }))}
                    className={`flex-1 py-3 px-4 rounded-xl border-2 transition-all
                      ${isActive 
                        ? 'border-primary-500 bg-primary-500/10 text-primary-400' 
                        : 'border-dark-700 hover:border-dark-600 text-dark-400 hover:text-dark-200'
                      }`}
                  >
                    <span className="text-sm font-medium">{size.label}</span>
                  </button>
                )
              })}
            </div>
            <p className="mt-2 text-xs text-dark-500">
              Adjusts the base font size throughout the application
            </p>
          </div>
        </div>

        {/* Footer */}
        <div className="px-6 py-4 border-t border-dark-700/50 bg-dark-850/50">
          <div className="flex justify-between items-center">
            <button
              onClick={() => {
                setSettings({ theme: 'dark', fontSize: 'medium' })
              }}
              className="text-sm text-dark-400 hover:text-dark-200 transition-colors"
            >
              Reset to defaults
            </button>
            <button
              onClick={onClose}
              className="px-4 py-2 rounded-lg bg-primary-600 hover:bg-primary-500 text-white font-medium transition-colors"
            >
              Done
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}
