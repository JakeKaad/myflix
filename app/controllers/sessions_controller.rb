class SessionsController < ApplicationController

  def new
    redirect_to home_path if current_user
  end

  def create
    @user = User.find_by email: params[:email]

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:info] = "Welcome back, #{@user.full_name}."
      redirect_to home_path
    else
      flash[:danger] = "Invalid email or password"
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "Successfully logged out"
    redirect_to root_path
  end

end