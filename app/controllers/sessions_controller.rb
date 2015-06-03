class SessionsController < ApplicationController
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      #log the user in and redirect to user's show page if the email and password are correct.
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination' #not quite right!
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in? #calling log_out only if logged_in? is true
    redirect_to root_url
  end
  
end
