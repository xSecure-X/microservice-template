module Api
  module V1
    class UsersController < ApplicationController
          before_action :set_user, only: [:show, :update, :destroy]
        
          def index
            @users = User.all
            render json: @users
          end
        
          def show
            render json: @user
          end
        
          def create
            user_service = User::UserCreator.new(user_params)
            @user = user_service.create_user
        
            if @user.persisted?
              render json: @user, status: :created
            else
              render json: @user.errors, status: :unprocessable_entity
            end
          end
        
          def update
            user_service = User::UserCreator.new(user_params)
            @user = user_service.update_user(@user)
        
            if @user.errors.empty?
              render json: @user
            else
              render json: @user.errors, status: :unprocessable_entity
            end
          end
        
          def destroy
            user_service = User::UserCreator.new(user_params)
            user_service.delete_user(@user)
            head :no_content
          end
        
          private
        
          def set_user
            @user = User.find(params[:id])
          end
        
          def user_params
            params.require(:user).permit(:full_name, :email, :roles, :status, :company_id, :created_date, :modified_date, :deleted_date)
          end
    end
  end
end
