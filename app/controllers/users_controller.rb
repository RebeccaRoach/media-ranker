class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    # use find so it won't try to go to the user show view and throw error instead
    @user = User.find(params[:id])
  end

end
