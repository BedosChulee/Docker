class Api::PostsController < ApplicationController
  # Posts API controller for managing post resources
  
  def index
    posts = Post.includes(:user).all
    render json: posts.as_json(include: :user), status: :ok
  end
  
  def show
    post = Post.includes(:user).find(params[:id])
    render json: post.as_json(include: :user), status: :ok
  end
  
  def create
    post = Post.new(post_params)
    
    if post.save
      render json: post.as_json(include: :user), status: :created
    else
      render json: {
        error: {
          message: "Failed to create post",
          details: post.errors.full_messages,
          code: "VALIDATION_ERROR"
        }
      }, status: :unprocessable_entity
    end
  end
  
  def update
    post = Post.find(params[:id])
    
    if post.update(post_params)
      render json: post.as_json(include: :user), status: :ok
    else
      render json: {
        error: {
          message: "Failed to update post",
          details: post.errors.full_messages,
          code: "VALIDATION_ERROR"
        }
      }, status: :unprocessable_entity
    end
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    head :no_content
  end
  
  private
  
  def post_params
    params.require(:post).permit(:title, :content, :user_id)
  end
end