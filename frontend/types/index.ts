// User interface based on the Rails User model
export interface User {
  id: number;
  name: string;
  email: string;
  created_at: string;
  updated_at: string;
}

// Post interface based on the Rails Post model
export interface Post {
  id: number;
  title: string;
  content: string;
  user_id: number;
  user: User;
  created_at: string;
  updated_at: string;
}

// Generic API response wrapper for handling API responses
export interface ApiResponse<T> {
  data?: T;
  error?: string;
  status: number;
}

// Specific API response types for posts
export interface PostsResponse extends ApiResponse<Post[]> {}
export interface PostResponse extends ApiResponse<Post> {}

// Specific API response types for users
export interface UsersResponse extends ApiResponse<User[]> {}
export interface UserResponse extends ApiResponse<User> {}