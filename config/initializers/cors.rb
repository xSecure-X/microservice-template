Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:4200' # Agrega aquí el origen permitido
    resource '/api/v1/roles/all', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
    resource '/api/v1/roles', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

