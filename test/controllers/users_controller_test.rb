require 'test_helper'

module Api
  module V1
    class UsersControllerTest < ActionController::TestCase
      def setup
        @user_params = {
          user: {
            full_name: "John Doe",
            email: "john@example.com",
            roles: "admin",
            status: "active",
            company_id: 1,
            created_date: Date.today,
            modified_date: Date.today,
            deleted_date: nil
          }
        }
      end

      test "should create user" do
        post :create, params: @user_params
        assert_response :created

        assert_equal "John Doe", User.last.full_name
        assert_equal "john@example.com", User.last.email
        # Asegúrate de realizar otras aserciones necesarias para verificar que los datos del usuario se hayan guardado correctamente.
      end
    end
  end
end
