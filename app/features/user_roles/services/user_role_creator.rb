# frozen_string_literal: true

module UserRoles
    module Services
        class UserRoleCreator
            def initialize(user_role_params={})
                @user_role_params = user_role_params
            end

            def create_user_role
                UserRole.create(@user_role_params)
            end

            def get_users(role)
                distinct_user_roles = UserRole.where(roleId: role.id).distinct(:userId)
                user_roles = User.where(id: distinct_user_roles.pluck(:userId)).select(:id, :full_name, :email)
                to_json(user_roles)
            end

            def delete_user_role(user_role)
                if user_role
                  user_role.destroy
                end
            end

            def to_json(users)
                {
                  result: users,
                  success: true,
                  message: ''
                }
            end
        end
    end
end