# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ::Api::V1::RolesController, type: :controller do
  let(:role_creator) { instance_double(::Roles::Services::RoleCreator) }
  let(:role) { instance_double(Role, name: 'Client', description: 'Description') }
  let(:role_id) { 'c449b856-test' }

  describe 'POST #create' do
    let(:valid_params) { { role: { name: 'Client', description: 'Description' } } }

    context 'with valid parameters' do
      before do
        allow(::Roles::Services::RoleCreator).to receive(:new).and_return(role_creator)
        allow(role_creator).to receive(:create_role).and_return(role)
        allow(role).to receive(:persisted?).and_return(true)
        allow(role).to receive(:errors).and_return({})
        allow(role).to receive(:as_json).and_return(valid_params[:role])
      end

      it 'creates a new role' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body).symbolize_keys).to eq({ success: true, message: '' })
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { role: { name: '', description: 'Administrador' } } }

      before do
        allow(::Roles::Services::RoleCreator).to receive(:new).and_return(role_creator)
        allow(role_creator).to receive(:create_role).and_return(role)
        allow(role).to receive(:persisted?).and_return(false)
        allow(role).to receive(:errors).and_return({ name: ["can't be blank"] })
      end

      it 'does not create a new role' do
        expect { post :create, params: invalid_params }.to change(Role, :count).by(0)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe 'PUT #update' do
    let(:valid_params) { { id: role_id, role: { name: 'Updated Role', description: 'Updated Description' } } }

    context 'with valid parameters' do
      before do
        allow(::Roles::Services::RoleCreator).to receive(:new).and_return(role_creator)
        allow(role_creator).to receive(:update_role).and_return(role)
        allow(role).to receive(:errors).and_return({})
        allow(role).to receive(:as_json).and_return(valid_params[:role])
      end

      it 'updates the role' do
        put :update, params: valid_params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).symbolize_keys).to eq({ success: true, message: '' })
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { id: role_id, role: { name: '', description: 'Updated description' } } }

      before do
        allow(::Roles::Services::RoleCreator).to receive(:new).and_return(role_creator)
        allow(role_creator).to receive(:update_role).and_return(role)
        allow(role).to receive(:errors).and_return({ name: ["can't be blank"] })
      end

      it 'does not update the role' do
        expect(role_creator).to receive(:update_role)
        put :update, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the role errors in the response' do
        put :update, params: invalid_params
        expect(response.body).to include("\"name\":[\"can't be blank\"]").or include("\"description\":[\"can't be blank\"]")
      end
    end
  end
  describe 'DELETE #destroy' do
    let(:role_param) { { id: role_id, role: { name: 'test', description: 'test' } } }

    before do
      allow(::Roles::Services::RoleCreator).to receive(:new).and_return(role_creator)
      allow(role_creator).to receive(:delete_role).and_return(role)
      allow(role).to receive_message_chain(:errors, :full_messages).and_return(['Error message'])
    end

    context 'when role is found' do
      it 'destroys the role' do
        allow(role).to receive(:destroyed?).and_return(true)
        delete :destroy, params: role_param
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when role is not found' do
      it 'returns a not found status' do
        allow(role).to receive(:destroyed?).and_return(false)
        delete :destroy, params: role_param
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
