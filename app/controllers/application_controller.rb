class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def redirect_if_not_signed_in
   redirect_to root_path if !user_signed_in?
  end

def redirect_if_signed_in
  redirect_to root_path if user_signed_in?
end
end
