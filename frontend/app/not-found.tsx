import Link from 'next/link'
import styles from '../styles/Home.module.css'

export default function NotFound() {
  return (
    <div className={styles.container}>
      <div className={styles.errorContainer}>
        <h1 className={styles.errorTitle}>404 - Page Not Found</h1>
        <p className={styles.errorMessage}>
          The page you're looking for doesn't exist or may have been moved.
        </p>
        <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center', flexWrap: 'wrap' }}>
          <Link href="/" className={styles.errorButton}>
            Go Home
          </Link>
          <button 
            onClick={() => window.history.back()} 
            className={styles.errorButton}
            style={{ backgroundColor: '#6c757d' }}
          >
            Go Back
          </button>
        </div>
        <div style={{ marginTop: '2rem', color: '#666' }}>
          <p>You might want to:</p>
          <ul style={{ textAlign: 'left', display: 'inline-block', marginTop: '1rem' }}>
            <li>Check the URL for typos</li>
            <li>Go back to the <Link href="/" style={{ color: '#0070f3' }}>homepage</Link></li>
            <li>Use the navigation menu above</li>
          </ul>
        </div>
      </div>
    </div>
  )
}