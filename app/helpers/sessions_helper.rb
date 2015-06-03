module SessionsHelper
  def log_in (user)
    session[:user_id] = user.id
  end
  
  #remembers a user in a persistent session.
  def remember (user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  #returns the user corresponding to the remember token cookie
  def current_user
    if (user_id = session[:user_id]) #if session of user id exists...
      @current_user ||= User.find_by(id: user_id) #find the user using the id stored in session
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)#if not then use the cookie that contains user id
      if user && user.authenticated?(cookies[:remember_token])#and if the data matches, check the token, then log in user.
        log_in user
        @current_user = user
      end
    end
  end
  
  #return true if the user is logged in, false if not.
  def logged_in?
    !current_user.nil? #Current user is not nil.
  end
  
  #Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end
