class RolesController < ApplicationController
    protect_from_forgery with: :null_session
    before_action :set_role, only: [:show, :edit, :update, :destroy]
  
    def index
      @roles = Role.all
      render json: @roles
    end
  
    def show
        if @role.nil?
            render json: {
              success: false,
              message: ""
            }, status: :not_found
        else
            render json: {
                result: {
                  id: @role.id,
                  name: @role.name,
                  description: @role.description,
                  create_at: @role.created_at.strftime("%Y-%m-%d")
                },
                success: true,
                message: ""
              }
            end
    end
  
    def new
      @role = Role.new
    end
  
    def create
      @role = Role.new(role_params)
      if @role.save
        render json: { success: true, message: "" }, status: :created
      else
        render json: { success: false, message: "" }, status: :unprocessable_entity
      end
    end
  
    def edit
    end
  
    def update
        if @role.nil?
            render json: {
              success: false,
              message: ""
            }, status: :not_found
        elsif @role.update(role_params)
            render json: { success: true, message: "" }, status: :ok
        else
            render json: { success: false, message: "" }, status: :unprocessable_entity
        end
    end
  
    def destroy
        if @role.nil?
            render json: {
              success: false,
              message: ""
            }, status: :not_found
        else @role.destroy
            render json: { success: true, message: "" },status: :no_content
        end
    end
  
    private
  
    def set_role
      @role = Role.find_by(id: params[:id])
    end
  
    def role_params
      params.require(:role).permit(:name, :description) # Customize the permitted attributes based on your Role model
    end
  end
  