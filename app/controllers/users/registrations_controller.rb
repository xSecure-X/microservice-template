class Users::RegistrationsController < Devise::RegistrationsController
  protect_from_forgery with: :exception
  
  private

  def sign_up_params
    params.require(:user).permit(:full_name,:telefono,:company_id,:roles,:status, :email, :password, :password_confirmation,:current_password)
  end

  def account_update_params
    authorize! :manage, @registrion
    params.require(:user).permit(:full_name,:telefono,:company_id,:roles,:status, :email, :password, :password_confirmation,:current_password)
  end

end
