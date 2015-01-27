class SessionsController < ApplicationController

  def new
    redirect_to home_path if current_user
  end

  def create
    @user = User.find_by email: params[:email]

    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to home_path, notice: "Welcome back, #{@user.full_name}."
    else
<<<<<<< HEAD
      flash[:error] = "Invalid email or password"
      redirect_to login_path
=======
      render :new
>>>>>>> origin/master
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Successfully logged out"
  end

end