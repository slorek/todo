class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  private
    def authenticate_user_from_token!
      if params[:authentication_email] or params[:authentication_token]
        
        return head :unauthorized if params[:authentication_email].blank? or params[:authentication_token].blank?
        
        user_email = params[:authentication_email].presence
        user       = user_email && User.find_by_email(user_email)

        if user && Devise.secure_compare(user.authentication_token, params[:authentication_token])
          sign_in user, store: false
        else
          return head :unauthorized
        end
      end
    end
end
