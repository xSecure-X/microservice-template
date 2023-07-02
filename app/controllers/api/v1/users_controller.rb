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
        if @user.nil?
          render json: {
            success: false,
            message: ""
          }, status: :not_found
        else
          render json: {
            result: @user,
            success: true,
            message: ""
          }
        end
      end

      def create
        user_service = ::Users::Services::UserCreator.new(user_params)
        @user = user_service.create_user
        if @user.persisted?
          render json: { success: true, message: "" }, status: :created
        else
          render json: { success: false, message: @user.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @user.nil?
          render json: {
            success: false,
            message: ""
          }, status: :not_found
        else
          user_service = ::Users::Services::UserCreator.new(user_params)
          @user = user_service.update_user(@user)
        
          if @user.errors.empty?
            render json: { success: true, message: '' }, status: :ok
          else
            render json: { success: true, message: @user.errors }, status: :unprocessable_entity
          end
        end
      end

      def destroy
        if @user.nil?
          render json: {
            success: false,
            message: ""
          }, status: :not_found
        else
          user_service = ::Users::Services::UserCreator.new
          user_service.delete_user(@user)
          render json: { success: true, message: '' },status: :no_content
        end
      end

      private

      def set_user
        @user = User.find_by(id: params[:id])
      end

      def user_params
        params.require(:user).permit(:full_name, :email, :roles, :status, :company_id)
      end
    end
  end
end
