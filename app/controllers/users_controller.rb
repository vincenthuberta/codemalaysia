class UsersController < ApplicationController
  before_action :logged_in_user,  only: [ :index, :edit, :update, :destroy ]
  before_action :correct_user,    only: [ :edit, :update ] 
  #execute the method edit and update only after executing correct_user
  before_action :admin_user,      only: :destroy
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated? 
  end
  
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
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
  
  #confirms a correct user
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
  
  private 
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
    end
end
