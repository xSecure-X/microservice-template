# frozen_string_literal: true

module Api
  module V1
    # User creator class
    class UsersController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_user, only: [:show, :update, :destroy]

      def index
        @users = User.all
        render json: @users
      end

      def show
        render json: @user
      end

      def create
        user_service = ::Users::Services::UserCreator.new(user_params)
        @user = user_service.create_user
        if @user.persisted?
          render json: @user, status: :created
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def update
        user_service = ::Users::Services::UserCreator.new(user_params)
        @user = user_service.update_user(@user)

        if @user.errors.empty?
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      def destroy
        user_service = ::Users::Services::UserCreator.new
        user_service.delete_user(@user)
        head :no_content
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:full_name, :email, :roles, :status, :company_id)
      end
    end
  end
end
