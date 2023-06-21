# spec/integration/users_spec.rb
require 'swagger_helper'

describe 'Api::V1::Users API' do
  path '/api/v1/users' do
    post 'Creates a new user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          full_name: { type: :string },
          email: { type: :string },
          roles: { type: :string },
          status: { type: :integer },
          company_id: { type: :string }
        },
        required: %w[full_name email]
      }

      response '201', 'Created' do
        let(:user) { { full_name: 'John Doe', email: 'john.doe@example.com', roles: 'admin', status: 1, company_id: '25678765434' } }
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:user) { { full_name: 'John Doe' } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '200', 'OK' do
        schema type: :object,
          properties: {
            full_name: { type: :string },
            email: { type: :string },
            roles: { type: :string },
            status: { type: :integer },
            company_id: { type: :string }
          },
          required: %w[full_name email]

        let(:user) { create(:user) }
        let(:id) { user.id }
        run_test!
      end

      response '404', 'Not Found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
  path '/api/v1/users' do
    get 'Retrieves all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'users found' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :string, format: :uuid },
              full_name: { type: :string },
              email: { type: :string },
              roles: { type: :string },
              status: { type: :integer },
              provider: { type: [:null, :string] },
              company_id: { type: [:null, :integer] },
              uid: { type: [:null, :string] },
              created_at: { type: :string, format: :'date-time' },
              modified_at: { type: :string, format: :'date-time' },
              telefono: { type: [:null, :string] },
              deleted_at: { type: [:null, :string] }
            },
            required: ['id', 'full_name', 'email', 'roles', 'status', 'created_at', 'modified_at']
          }

        run_test!
      end
    end
  end
end
