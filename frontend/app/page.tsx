import Link from 'next/link';
import { fetchPosts, Post } from '../lib/api';
import styles from '../styles/Home.module.css';

// Function to get posts with error handling
async function getPosts(): Promise<Post[]> {
  try {
    const posts = await fetchPosts();
    return posts;
  } catch (error) {
    console.error('Error fetching posts:', error);
    throw error;
  }
}

// Function to format date for display
function formatDate(dateString: string): string {
  const date = new Date(dateString);
  return date.toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
}

// Function to create excerpt from content
function createExcerpt(content: string, maxLength: number = 150): string {
  if (content.length <= maxLength) {
    return content;
  }
  return content.substring(0, maxLength).trim() + '...';
}

export default async function HomePage() {
  try {
    const posts = await getPosts();

    if (!posts || posts.length === 0) {
      return (
        <div className={styles.container}>
          <h1>Latest Posts</h1>
          <div className={styles.emptyState}>
            <h2>No posts available</h2>
            <p>There are currently no posts to display. Check back later!</p>
          </div>
        </div>
      );
    }

    return (
      <div className={styles.container}>
        <h1>Latest Posts</h1>
        <div className={styles.postsGrid}>
          {posts.map((post) => (
            <article key={post.id} className={styles.postCard}>
              <Link href={`/posts/${post.id}`} className={styles.postTitle}>
                {post.title}
              </Link>
              
              <div className={styles.postMeta}>
                <span>By <span className={styles.postAuthor}>{post.user.name}</span></span>
                <span className={styles.postDate}>
                  • {formatDate(post.created_at)}
                </span>
              </div>
              
              <p className={styles.postExcerpt}>
                {createExcerpt(post.content)}
              </p>
              
              <Link href={`/posts/${post.id}`} className={styles.readMore}>
                Read more →
              </Link>
            </article>
          ))}
        </div>
      </div>
    );
  } catch (error) {
    console.error('HomePage error:', error);
    
    // Handle different types of errors
    const errorMessage = error instanceof Error ? error.message : 'An unexpected error occurred';
    
    return (
      <div className={styles.container}>
        <h1>Latest Posts</h1>
        <div className={styles.errorContainer}>
          <h2 className={styles.errorTitle}>Unable to Load Posts</h2>
          <p className={styles.errorMessage}>
            {errorMessage.includes('Network error') || errorMessage.includes('connect') 
              ? 'Unable to connect to the server. Please check your connection and try again.'
              : errorMessage.includes('Server error')
              ? 'The server is currently experiencing issues. Please try again later.'
              : 'There was a problem loading the posts. Please try again later.'
            }
          </p>
          <Link href="/" className={styles.errorButton}>
            Try Again
          </Link>
        </div>
      </div>
    );
  }
}