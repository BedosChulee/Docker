class Api::UsersController < ApplicationController
  # Users API controller for managing user resources
  
  def index
    users = User.all
    render json: users, status: :ok
  end
  
  def show
    user = User.find(params[:id])
    render json: user, status: :ok
  end
  
  def create
    user = User.new(user_params)
    
    if user.save
      render json: user, status: :created
    else
      render json: {
        error: {
          message: "Failed to create user",
          details: user.errors.full_messages,
          code: "VALIDATION_ERROR"
        }
      }, status: :unprocessable_entity
    end
  end
  
  def update
    user = User.find(params[:id])
    
    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: {
        error: {
          message: "Failed to update user",
          details: user.errors.full_messages,
          code: "VALIDATION_ERROR"
        }
      }, status: :unprocessable_entity
    end
  end
  
  def destroy
    user = User.find(params[:id])
    user.destroy
    head :no_content
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end