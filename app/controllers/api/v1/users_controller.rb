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
        return if user_check_null
        render json: ::Users::Services::UserCreator.new.to_json(@user)
      end

      def create
        @user = ::Users::Services::UserCreator.new(user_params).create_user

        if @user.persisted?
          render json: { success: true, message: "" }, status: :created
        else
          render json: { success: false, message: @user.errors }, status: :unprocessable_entity
        end
      end

      def update
        return if user_check_null
        @user = ::Users::Services::UserCreator.new(user_params).update_user(@user)
        
        if @user.errors.empty?
          render json: { success: true, message: '' }, status: :ok
        else
          render json: { success: false, message: @user.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        return if user_check_null
        @user = ::Users::Services::UserCreator.new.delete_user(@user)

        if @user.deleted?
          render json: { success: true, message: '' }, status: :ok
        else
          render json: { success: false, message: @user.errors }, status: :unprocessable_entity
        end
        
      end

      private

      def set_user
        @user = User.find_by(id: params[:id])
      end

      def user_params
        params.require(:user).permit(:full_name, :email, :roles, :status, :company_id)
      end

      def user_check_null
        return false unless @user.nil?

          render json: {
            success: false,
            message: ''
          }, status: :not_found
        end
      end
  end
end
