require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "GET index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "returns all users as JSON" do
      user1 = User.create("id":"d83ee234-9e8a-4703-8357-28d8bf617eb9","full_name":"Bradley Sánchez","email":"brandsan15@gmail.com","roles":"cliente","status":1,"provider":"google_oauth2","uid":"118254811605690573792","created_at":"2023-06-16T03:27:57.284Z","modified_at":"2023-06-16T03:27:57.284Z")
      get :index
      expect(response.body).to eq([user1].to_json)
    end
  end

  describe "GET show" do
    it "returns a successful response" do
      user = User.create("id":"27884733-9053-4545-8563-89825fa80d51","full_name":"Bradley Sánchez","email":"brasan15@gmail.com",
        "roles":"cliente","status":1,"provider":"google_oauth2","uid":"118254811605690573792","created_at":"2023-06-14T04:17:00.320Z","modified_at":"2023-06-14T04:17:00.320Z")
      
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end

    it "returns the user as JSON" do
      user = User.create("id":"27884733-9053-4545-8563-89825fa80d51","full_name":"Bradley Sánchez","email":"brasan15@gmail.com",
        "roles":"cliente","status":1,"provider":"google_oauth2","uid":"118254811605690573792","created_at":"2023-06-14T04:17:00.320Z","modified_at":"2023-06-14T04:17:00.320Z")

      get :show, params: { id: user.id }
      expect(response.body).to eq(user.to_json)
    end
  end

  describe "POST create" do
    it "creates a new user with valid parameters" do
      user_params = { full_name:"Johel Sánchez",email:"brandsa21@gmail.com",
        roles:"cliente",status:1, company_id:"123"}
      expect {
        post :create, params: { user: user_params }
      }.to change(User, :count).by(1)
      user = User.order(created_at: :desc).first
      
      expect(response).to have_http_status(:created)
      expect(response.body).to eq(user.to_json)
    end

    it "returns an error with invalid parameters" do
      user_params = { full_name: "", email: "brand@gmail.com", status: "d" }

      expect {
        post :create, params: { user: user_params }
      }.not_to change(User, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("\"full_name\":[\"can't be blank\"]").or include("\"email\":[\"can't be blank\"]").or include("\"status\":[\"can't be blank\",\"is not a number\"]")
    end
  end

  describe "PATCH update" do
    it "updates an existing user with valid parameters" do
      user = User.create("id":"27884733-9053-4545-8563-89825fa80d51","full_name":"Bradley Sánchez","email":"brasan15@gmail.com",
        "roles":"cliente","status":1,"provider":"google_oauth2","uid":"118254811605690573792","created_at":"2023-06-14T04:17:00.320Z","modified_at":"2023-06-14T04:17:00.320Z")
      updated_params = { "full_name": "Johel Alvarez" }

      patch :update, params: { id: user.id, user: updated_params }

      user.reload
      expect(user.full_name).to eq("Johel Alvarez")
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(JSON.parse(user.to_json))
    end

    it "returns an error with invalid parameters" do
      user = User.create("id":"27884733-9053-4545-8563-89825fa80d51","full_name":"Bradley Sánchez","email":"brasan15@gmail.com",
        "roles":"cliente","status":1,"provider":"google_oauth2","uid":"118254811605690573792","created_at":"2023-06-14T04:17:00.320Z","modified_at":"2023-06-14T04:17:00.320Z")
      invalid_params = { email: "" }

      patch :update, params: { id: user.id, user: invalid_params }

      user.reload
      expect(user.email).to eq("brasan15@gmail.com")
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("\"full_name\":[\"can't be blank\"]").or include("\"email\":[\"can't be blank\"]").or include("\"status\":[\"can't be blank\",\"is not a number\"]")
    end
  end

  describe "DELETE destroy" do
    it "deletes an existing user" do
      user = User.create("id":"27884733-9053-4545-8563-89825fa80d51","full_name":"Bradley Sánchez","email":"brasan15@gmail.com",
        "roles":"cliente","status":1,"provider":"google_oauth2","uid":"118254811605690573792","created_at":"2023-06-14T04:17:00.320Z","modified_at":"2023-06-14T04:17:00.320Z")
      expect {
        delete :destroy, params: { id: user.id }, format: :json
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
