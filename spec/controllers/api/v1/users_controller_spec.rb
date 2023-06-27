# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Api::V1::UsersController, type: :controller do
  let(:user_creator) { instance_double(::Users::Services::UserCreator) }
  let(:user) { instance_double(User) }

  describe 'POST #create' do
    let(:valid_params) { { user: { full_name: 'John Doe', email: 'john@example.com', roles: 'user', status: 'active', company_id: 1 } } }

    context 'with valid parameters' do
      before do
        allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
        allow(user_creator).to receive(:create_user).and_return(user)
        allow(user).to receive(:persisted?).and_return(true)
        allow(user).to receive(:errors).and_return({})
        allow(user).to receive(:as_json).and_return(valid_params[:user])
      end

      it 'creates a new user' do
        expect { post :create, params: valid_params }.to change(User, :count).by(1)
      end

      it 'returns a JSON response with the created user' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body).symbolize_keys).to eq(valid_params[:user])
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user: { full_name: '', email: 'john@example.com', roles: 'user', status: 'active', company_id: 1 } } }

      before do
        allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
        allow(user_creator).to receive(:create_user).and_return(user)
        allow(user).to receive(:persisted?).and_return(false)
        allow(user).to receive(:errors).and_return({ full_name: ["can't be blank"] })
      end

      it 'does not create a new user' do
        expect { post :create, params: invalid_params }.to change(User, :count).by(0)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
