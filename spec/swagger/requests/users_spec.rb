require 'swagger_helper'

RSpec.describe 'Api::V1::Users API', type: :request do
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

    get 'Retrieves all users' do
      tags 'Users'
      produces 'application/json'

      response '200', 'Users found' do
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

    patch 'Updates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :integer
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          full_name: { type: :string },
          email: { type: :string },
          roles: { type: :string },
          status: { type: :integer },
          company_id: { type: :string }
        }
      }

      response '200', 'OK' do
        let(:user) { create(:user) }
        let(:id) { user.id }
        let(:user_params) { { full_name: 'Updated Name' } }
        run_test!
      end

      response '422', 'Unprocessable Entity' do
        let(:id) { 'invalid' }
        let(:user_params) { { full_name: 'Updated Name' } }
        run_test!
      end
    end

    delete 'Deletes a user' do
      tags 'Users'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer

      response '204', 'No Content' do
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
end
