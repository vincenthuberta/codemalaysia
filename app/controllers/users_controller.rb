class UsersController < ApplicationController
  before_action :logged_in_user,  only: [ :index, :edit, :update, :destroy ]
  before_action :correct_user,    only: [ :edit, :update ] 
  #execute the method edit and update only after executing correct_user
  before_action :admin_user,      only: :destroy
  
  def show
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
    
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Sign up is successful. Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new' #run the new method
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  #create before filters
  #Confirms a logged-in user
  def logged_in_user
    unless logged_in?
      store_location 
      #store the location so that once logged in, can directly go to the link the user wants. Friednly forwarding.
      flash[:danger] = "Please log in." #whenever not logged in, flash this.
      redirect_to login_url
    end
  end
  
  #confirms a correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  private 
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
