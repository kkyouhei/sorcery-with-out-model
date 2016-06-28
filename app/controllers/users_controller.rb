class UsersController < ApplicationController
  skip_before_filter :require_login, only: [:index, :new, :create]

  def index
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
