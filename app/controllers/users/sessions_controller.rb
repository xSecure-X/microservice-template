class Users::SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, only: [:after_sign_out_path_for, :after_sign_in_path_for]
  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || root_path
  end
  
end
