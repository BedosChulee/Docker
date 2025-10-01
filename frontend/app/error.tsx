'use client'

import Link from 'next/link'
import styles from '../styles/Home.module.css'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  // Check if it's a network/API error
  const isNetworkError = error.message.includes('fetch') || 
                        error.message.includes('network') || 
                        error.message.includes('Failed to fetch') ||
                        error.message.includes('API')

  const getErrorMessage = () => {
    if (isNetworkError) {
      return "We're having trouble connecting to our servers. Please check your internet connection and try again."
    }
    return error.message || "An unexpected error occurred. Please try again."
  }

  const getErrorTitle = () => {
    if (isNetworkError) {
      return "Connection Problem"
    }
    return "Something went wrong!"
  }

  return (
    <div className={styles.container}>
      <div className={styles.errorContainer}>
        <h1 className={styles.errorTitle}>{getErrorTitle()}</h1>
        <p className={styles.errorMessage}>
          {getErrorMessage()}
        </p>
        <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
          <button 
            onClick={() => reset()} 
            className={styles.errorButton}
          >
            Try Again
          </button>
          <Link href="/" className={styles.errorButton}>
            Go Home
          </Link>
        </div>
        {process.env.NODE_ENV === 'development' && (
          <details style={{ marginTop: '2rem', textAlign: 'left', maxWidth: '600px', margin: '2rem auto 0' }}>
            <summary style={{ cursor: 'pointer', color: '#666', marginBottom: '1rem' }}>
              Technical Details (Development Only)
            </summary>
            <pre style={{ 
              background: '#f5f5f5', 
              padding: '1rem', 
              borderRadius: '4px', 
              fontSize: '0.875rem',
              overflow: 'auto',
              color: '#333'
            }}>
              {error.stack || error.message}
            </pre>
          </details>
        )}
      </div>
    </div>
  )
}