class Admin::UsersController < ApplicationController

  before_action :require_admin

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def create

    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "#{@user.full_name} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_user_path(@user)
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to admin_users_path
  end

protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :admin_user,:password, :password_confirmation)
  end
 

  def require_admin
    unless current_user.admin?
      flash[:error] = "You must be an administrator to access this section"
      redirect_to movies_path
    end
  end


end
