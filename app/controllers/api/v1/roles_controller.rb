# frozen_string_literal: true

module Api
  module V1
    # User creator class
    class RolesController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :set_role, only: %i[show edit update destroy]

      def index
        @roles = Role.all
        render json: @roles
      end

      def show
        role_check_null
        render json: ::Roles::Services::RoleCreator.new.to_json(@role)
      end

      def new
        @role = Role.new
      end

      def create
        @role = ::Roles::Services::RoleCreator.new(role_params).create_role

        if @role.persisted?
          render json: { success: true, message: '' }, status: :created
        else
          render json: { success: false, message: @role.errors }, status: :unprocessable_entity
        end
      end

      def update
        role_check_null
        @role = ::Roles::Services::RoleCreator.new(role_params).update_role(@role)

        if @role.errors.empty?
          render json: { success: true, message: '' }, status: :ok
        else
          render json: { success: false, message: @role.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        role_check_null
       
        if @role.destroy
          render json: { success: true, message: '' }, status: :ok
        else
          render json: { success: false, message: @role.errors }, status: :unprocessable_entity
        
      end
      
      end

      private

      def set_role
        @role = Role.find_by(id: params[:id])
      end

      def role_params
        params.require(:role).permit(:name, :description) # Customize the permitted attributes based on your Role model
      end

      def role_check_null
        if @role.nil?
          render json: {
            success: false,
            message: 'Role not found.'
          }, status: :not_found
        end
      end
    end
  end
end
