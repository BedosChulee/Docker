class HealthController < ApplicationController
  # GET /health
  def show
    db = check_database_connection

    if db[:connected]
      render json: {
        status: 'ok',
        database: db[:status],
        timestamp: Time.current.iso8601
      }, status: :ok
    else
      render json: {
        status: 'error',
        database: db[:status],
        error: db[:error],
        timestamp: Time.current.iso8601
      }, status: :service_unavailable
    end
  end

  private

  def check_database_connection
    # court timeout pour éviter de bloquer longtemps
    timeout_seconds = 2

    begin
      value = nil
      Timeout.timeout(timeout_seconds) do
        # Utiliser le connection pool proprement
        ActiveRecord::Base.connection_pool.with_connection do |conn|
          # SELECT 1; pour Postgres on peut aussi SELECT version();
          value = conn.select_value('SELECT 1')
        end
      end

      if value.to_s == "1"
        { connected: true, status: 'connected' }
      else
        { connected: false, status: 'unknown', error: "unexpected response: #{value.inspect}" }
      end

    rescue Timeout::Error => e
      { connected: false, status: 'timeout', error: e.message }
    rescue ActiveRecord::ConnectionNotEstablished => e
      { connected: false, status: 'disconnected', error: e.message }
    rescue PG::Error, Mysql2::Error => e
      # couvre les erreurs DB spécifiques (Postgres et MySQL)
      { connected: false, status: 'error', error: e.message }
    rescue => e
      { connected: false, status: 'error', error: e.message }
    end
  end
end