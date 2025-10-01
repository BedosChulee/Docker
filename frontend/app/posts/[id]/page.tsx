import Link from 'next/link';
import { fetchPost } from '../../../lib/api';
import { Post } from '../../../types';
import styles from './page.module.css';
import RetryButton from './RetryButton';

// Fetch post data on the server side
async function getPost(id: string): Promise<Post> {
  try {
    const post = await fetchPost(id);
    return post;
  } catch (error) {
    // Re-throw the error to be handled by the error boundary
    throw error;
  }
}

export default async function PostPage({ params }: { params: { id: string } }) {
  try {
    const post = await getPost(params.id);
    
    return (
      <div className={styles.container}>
        <div className={styles.navigation}>
          <Link href="/" className={styles.backLink}>
            ← Back to Home
          </Link>
        </div>
        
        <article className={styles.postDetail}>
          <header className={styles.postHeader}>
            <h1 className={styles.postTitle}>{post.title}</h1>
            <div className={styles.postMeta}>
              <p>By <strong>{post.user.name}</strong></p>
              <p>Published on {new Date(post.created_at).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
              })}</p>
            </div>
          </header>
          
          <div className={styles.postContent}>
            {post.content.split('\n').map((paragraph, index) => (
              <p key={index}>{paragraph}</p>
            ))}
          </div>
          
          <footer className={styles.postFooter}>
            <div className={styles.authorInfo}>
              <h3>About the Author</h3>
              <p><strong>{post.user.name}</strong></p>
              <p>Email: {post.user.email}</p>
              <p>Member since {new Date(post.user.created_at).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long'
              })}</p>
            </div>
          </footer>
        </article>
      </div>
    );
  } catch (error) {
    // Handle different types of errors
    const errorMessage = error instanceof Error ? error.message : 'An unexpected error occurred';
    
    // Check if it's a 404 error
    if (errorMessage.includes('not found') || errorMessage.includes('404')) {
      return (
        <div className={styles.container}>
          <div className={styles.navigation}>
            <Link href="/" className={styles.backLink}>
              ← Back to Home
            </Link>
          </div>
          
          <div className={styles.errorContainer}>
            <h1>Post Not Found</h1>
            <p>The post you're looking for doesn't exist or may have been removed.</p>
            <Link href="/" className={styles.homeButton}>
              Return to Home
            </Link>
          </div>
        </div>
      );
    }
    
    // Handle network/connectivity errors
    return (
      <div className={styles.container}>
        <div className={styles.navigation}>
          <Link href="/" className={styles.backLink}>
            ← Back to Home
          </Link>
        </div>
        
        <div className={styles.errorContainer}>
          <h1>Connection Error</h1>
          <p>Unable to load the post. Please check your connection and try again.</p>
          <p className={styles.errorDetails}>{errorMessage}</p>
          <div className={styles.errorActions}>
            <RetryButton className={styles.retryButton} />
            <Link href="/" className={styles.homeButton}>
              Return to Home
            </Link>
          </div>
        </div>
      </div>
    );
  }
}