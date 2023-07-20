# frozen_string_literal: true

module Roles
  module Services
    # Role creator class
    class RoleCreator
      def initialize(role_params={})
        @role_params = role_params
      end

      def create_role
        Role.create(@role_params)
      end

      def update_role(role)
        role.update(@role_params)
        role
      end

      def delete_role(role)
        if role
          role.destroy
        end
      end

      def to_json(role)
        {
          result: role,
          success: true,
          message: ''
        }
      end
    end
  end
end
