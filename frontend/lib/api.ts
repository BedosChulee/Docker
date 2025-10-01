// API client for communicating with the Rails backend
// Handles HTTP requests and error management

// Types for API responses
export interface User {
  id: number;
  name: string;
  email: string;
  created_at: string;
  updated_at: string;
}

export interface Post {
  id: number;
  title: string;
  content: string;
  user_id: number;
  user: User;
  created_at: string;
  updated_at: string;
}

export interface ApiResponse<T> {
  data?: T;
  error?: string;
  status: number;
}

// Get API base URL from environment variables
const getApiBaseUrl = (): string => {
  return process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';
};

// Generic fetch wrapper with error handling
async function apiRequest<T>(endpoint: string): Promise<T> {
  const baseUrl = getApiBaseUrl();
  const url = `${baseUrl}${endpoint}`;
  
  try {
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    });

    if (!response.ok) {
      if (response.status === 404) {
        throw new Error('Resource not found');
      }
      if (response.status >= 500) {
        throw new Error('Server error occurred');
      }
      throw new Error(`HTTP error! status: ${response.status}`);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    if (error instanceof TypeError && error.message.includes('fetch')) {
      throw new Error('Network error: Unable to connect to the API server');
    }
    throw error;
  }
}

/**
 * Fetch all posts from the backend API
 * @returns Promise<Post[]> Array of posts with user information
 * @throws Error if the request fails or network is unavailable
 */
export async function fetchPosts(): Promise<Post[]> {
  try {
    const posts = await apiRequest<Post[]>('/api/posts');
    return posts;
  } catch (error) {
    console.error('Error fetching posts:', error);
    throw new Error(
      error instanceof Error 
        ? error.message 
        : 'Failed to fetch posts from the server'
    );
  }
}

/**
 * Fetch a specific post by ID from the backend API
 * @param id - The post ID to fetch
 * @returns Promise<Post> The post with user information
 * @throws Error if the post is not found or request fails
 */
export async function fetchPost(id: string | number): Promise<Post> {
  try {
    const post = await apiRequest<Post>(`/api/posts/${id}`);
    return post;
  } catch (error) {
    console.error(`Error fetching post ${id}:`, error);
    
    if (error instanceof Error && error.message.includes('not found')) {
      throw new Error('Post not found');
    }
    
    throw new Error(
      error instanceof Error 
        ? error.message 
        : `Failed to fetch post ${id} from the server`
    );
  }
}