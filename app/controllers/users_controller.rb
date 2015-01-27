class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "Successfully registered."
      session[:user_id] = @user.id
<<<<<<< HEAD
      redirect_to home_path
=======
      redirect_to root_path
>>>>>>> origin/master
    else
      render :new
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :full_name)
    end

end