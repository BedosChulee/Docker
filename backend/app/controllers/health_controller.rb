class HealthController < ApplicationController
  # Health check endpoint for monitoring application and database status
  
  def show
    database_status = check_database_connection
    
    if database_status[:connected]
      render json: {
        status: 'ok',
        database: database_status[:status],
        timestamp: Time.current.iso8601
      }, status: :ok
    else
      render json: {
        status: 'error',
        database: database_status[:status],
        error: database_status[:error],
        timestamp: Time.current.iso8601
      }, status: :service_unavailable
    end
  end
  
  private
  
  def check_database_connection
    begin
      ActiveRecord::Base.connection.execute('SELECT 1')
      { connected: true, status: 'connected' }
    rescue => e
      { connected: false, status: 'disconnected', error: e.message }
    end
  end
end