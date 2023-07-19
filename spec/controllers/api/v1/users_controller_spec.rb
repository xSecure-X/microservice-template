# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Api::V1::UsersController, type: :controller do
  let(:user_creator) { instance_double(::Users::Services::UserCreator) }
  let(:user) { instance_double(User, full_name: 'John Doe', email: 'john@example.com', roles: 'user', status: 1, company_id: '123') }
  let(:user_id) { 'd64a76e9-test' }

  describe 'POST #create' do
    let(:valid_params) { { user: { full_name: 'John Doe', email: 'john@example.com', roles: 'user', status: 1, company_id: '123' } } }

    context 'with valid parameters' do
      before do
        allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
        allow(user_creator).to receive(:create_user).and_return(user)
        allow(user).to receive(:persisted?).and_return(true)
        allow(user).to receive(:errors).and_return({})
        allow(user).to receive(:as_json).and_return(valid_params[:user])
      end

      it 'creates a new user' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body).symbolize_keys).to eq({ success: true, message: '' })
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
  describe 'PUT #update' do
    let(:valid_params) { { id: user_id, user: { full_name: 'Updated User', email: 'Updated email', roles: 'cliente', status: 1, company_id: '123' } } }

    context 'with valid parameters' do
      before do
        allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
        allow(user_creator).to receive(:update_user).and_return(user)
        allow(user).to receive(:errors).and_return({})
        allow(user).to receive(:as_json).and_return(valid_params[:user])
        allow(User).to receive(:find_by).with(id: user_id).and_return(user)
      end

      it 'updates the user' do
        put :update, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).symbolize_keys).to eq({ success: true, message: '' })
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { id: user_id, user: { full_name: '', email: 'johndoe@example.com', roles:'cliente', status: 1, company_id: "123" } } }

      before do
        allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
        allow(user_creator).to receive(:update_user).and_return(user)
        allow(user).to receive(:errors).and_return({ full_name: ["can't be blank"] })
        allow(User).to receive(:find_by).with(id: user_id).and_return(user)
      end

      it 'does not update the user' do
        expect(user_creator).to receive(:update_user)
        put :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the user errors in the response' do
        put :update, params: invalid_params
        expect(response.body).to include("\"full_name\":[\"can't be blank\"]").or include("\"email\":[\"can't be blank\"]").or include("\"status\":[\"can't be blank\",\"is not a number\"]")
      end
    end
  end
  describe 'DELETE #destroy' do
    let(:user_param) { { id: user_id, user: { full_name: 'test', email: 'test@test.com', roles: 'cliente', status: 1, company_id: '123' } } }

    before do
      allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
      allow(user_creator).to receive(:delete_user).and_return(user)
      allow(user).to receive_message_chain(:errors, :full_messages).and_return(['Error message'])
      allow(User).to receive(:find_by).with(id: user_id).and_return(user)
    end

    context 'when user is found' do
      it 'destroys the user' do
        allow(user).to receive(:deleted?).and_return(true)
        delete :destroy, params: user_param
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when user is not found' do
      it 'returns a not found status' do
        allow(user).to receive(:deleted?).and_return(false)
        delete :destroy, params: user_param
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
