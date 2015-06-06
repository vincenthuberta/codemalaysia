class SessionsController < ApplicationController
  def new
  end
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
    log_in @user
    params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    redirect_back_or @user #redirect user to the url the user wanted after they sign up.
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
