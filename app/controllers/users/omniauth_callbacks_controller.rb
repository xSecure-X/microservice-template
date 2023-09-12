class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token, only: [:google_oauth2, :auth]
  def google_oauth2
    user = User.from_omniauth(auth)
    if user.present?
      sign_out_all_scopes
      flash[:success] = t 'devise.omniauth_callbacks.success', kind: 'Google'
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = 
      t 'devise.omniauth_callbacks.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
      redirect_to new_user_session_path
    end
  end

  private

  def auth
      @auth ||= request.env["omniauth.auth"]
  end
  
end
