# frozen_string_literal: true

module Api
  module V1
    # User creator class
    class UsersController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_user, only: [:show, :update, :destroy,:verify_code]

      def index
        @users = User.all
        render json: @users
      end

      def show
        return if user_check_null
        render json: ::Users::Services::UserCreator.new.to_json(@user)
      end

      def create
        # Genera el código anfitrión único
        code = generate_unique_code

        # Combina el código anfitrión con los parámetros del usuario
        user_params_with_code = user_params.merge(code: code)

        @user = ::Users::Services::UserCreator.new(user_params_with_code).create_user

        if @user.persisted?
          render json: { success: true, message: "" }, status: :created
        else
          render json: { success: false, message: @user.errors }, status: :unprocessable_entity
        end
      end

      def generate_unique_code
        loop do
          code = rand(10000) # Genera un número aleatorio de 0 a 9999
          return code unless User.exists?(code: code)
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

      def verify_code
        user_id = params[:id]
        code = params[:code].to_i

        @user = User.find_by(id: user_id)

        if @user.nil?
          render json: { success: false, message: @user.errors }, status: :not_found
        elsif @user.code == code
          render json: { success: true, message: 'Code verified' }, status: :ok
        else
          render json: { success: false, message: 'Incorrect code' }, status: :unprocessable_entity
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
