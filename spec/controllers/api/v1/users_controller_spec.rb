require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "returns all users as JSON" do
      user1 = User.create(full_name: "John Doe", email: "john@example.com")
      user2 = User.create(full_name: "Jane Smith", email: "jane@example.com")

      get :index
      expect(response.body).to eq([user1, user2].to_json)
    end
  end

  describe "GET show" do
    it "returns a successful response" do
      user = User.create(full_name: "John Doe", email: "john@example.com")

      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it "returns the user as JSON" do
      user = User.create(full_name: "John Doe", email: "john@example.com")

      get :show, params: { id: user.id }
      expect(response.body).to eq(user.to_json)
    end
  end

  describe "POST create" do
    it "creates a new user with valid parameters" do
      user_params = { full_name: "John Doe", email: "john@example.com" }

      expect {
        post :create, params: { user: user_params }
      }.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.body).to eq(User.last.to_json)
    end

    it "returns an error with invalid parameters" do
      user_params = { full_name: "", email: "" }

      expect {
        post :create, params: { user: user_params }
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Full name can't be blank", "Email can't be blank")
    end
  end

  describe "PATCH update" do
    it "updates an existing user with valid parameters" do
      user = User.create(full_name: "John Doe", email: "john@example.com")
      updated_params = { full_name: "Updated Name" }

      patch :update, params: { id: user.id, user: updated_params }

      user.reload
      expect(user.full_name).to eq("Updated Name")
      expect(response).to be_successful
      expect(response.body).to eq(user.to_json)
    end

    it "returns an error with invalid parameters" do
      user = User.create(full_name: "John Doe", email: "john@example.com")
      invalid_params = { email: "" }

      patch :update, params: { id: user.id, user: invalid_params }

      user.reload
      expect(user.email).to eq("john@example.com")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Email can't be blank")
    end
  end

  describe "DELETE destroy" do
    it "deletes an existing user" do
      user = User.create(full_name: "John Doe", email: "john@example.com")

      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
