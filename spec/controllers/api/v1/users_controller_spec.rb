# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Api::V1::UsersController, type: :controller do
  let(:user_creator) { instance_double(::Users::Services::UserCreator) }
  let(:user) { instance_double(User) }

  describe 'POST #create' do
    let(:valid_params) { { user: { full_name: 'John Doe', email: 'john@example.com', users: 'user', status: 1, company_id: '123' } } }

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
      let(:invalid_params) { { user: { full_name: '', email: 'john@example.com', users: 'user', status: 'active', company_id: 1 } } }

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
    let(:user_id) { 'd64a76e9-0d80-4bc2-abd5-3c246425c7ef' }
    let(:valid_params) { { id: user_id, user: { full_name: 'Updated User', email: 'Updated Description', roles: 'cliente', status: 1, company_id: '123' } } }

    context 'with valid parameters' do
      before do
        allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
        allow(user_creator).to receive(:update_user).and_return(user)
        allow(user).to receive(:errors).and_return({})
        allow(user).to receive(:as_json).and_return(valid_params[:user])
      end

      it 'updates the user' do
        put :update, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).symbolize_keys).to eq({ success: true, message: '' })
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { id: user_id, user: { full_name: 'Updated', email: 'johndoe@example.com', roles:'cliente', status: 1, company_id: "123" } } }

      before do
        allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
        allow(user_creator).to receive(:update_user).and_return(user)
        allow(user).to receive(:errors).and_return({ full_name: ["can't be blank"] })
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
    let(:user_id) { 'd64a76e9-0d80-4bc2-abd5-3c246425c7ef' }
    let(:nonexistent_user_id) { 'c449b856-4dda-4adb-9111-f932846b7008' }

    before do
      allow(User).to receive(:find).with(user_id).and_return(user)
      allow(::Users::Services::UserCreator).to receive(:new).and_return(user_creator)
    end

    context 'when user is found' do
      let(:user_creator) { instance_double(::Users::Services::UserCreator) }

      it 'destroys the user' do
        allow(user_creator).to receive(:delete_user)
        delete :destroy, params: { id: user_id }
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'when user is not found' do
      let(:user_creator) { instance_double(::Users::Services::UserCreator) }

      it 'returns a not found status' do
        allow(User).to receive(:find).with(nonexistent_user_id).and_raise(ActiveRecord::RecordNotFound)
        delete :destroy, params: { id: nonexistent_user_id }
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
