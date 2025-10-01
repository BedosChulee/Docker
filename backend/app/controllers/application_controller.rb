class ApplicationController < ActionController::API
  # Base controller for API endpoints
  # Provides common functionality for all API controllers
  
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  
  private
  
  def record_not_found(exception)
    render json: {
      error: {
        message: "Resource not found",
        details: [exception.message],
        code: "NOT_FOUND"
      }
    }, status: :not_found
  end
  
  def record_invalid(exception)
    render json: {
      error: {
        message: "Validation failed",
        details: exception.record.errors.full_messages,
        code: "VALIDATION_ERROR"
      }
    }, status: :unprocessable_entity
  end
end