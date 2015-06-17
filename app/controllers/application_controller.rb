class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
    #Confirms a logged-in user
    def logged_in_user
      unless logged_in? #run the codes below except user is already logged in.
        store_location #to take note of which url the user is in now..
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end
