class UsersController < ApplicationController

  def login_form
    @user = User.new
  end

  def login
    @user = User.find_by(user_name: params[:user][:user_name])

    if @user.nil?
      # new user
      @user = User.new(user_name: params[:user][:user_name])
      if ! @user.save
        flash[:error] = "Unable to log in"
        redirect_to root_path
        return
      end
    else
      # existing user
      flash[:success] = "Successfully logged in as existing user #{@user.user_name}"
    end

    # set session id for new or existing user
    session[:user_id] = @user.id
    redirect_to root_path
  end

  def logout
    if session[:user_id]
      user = User.find_by(id: session[:user_id])
      unless user.nil?
        session[:user_id] = nil
        flash[:success] = "Successfully logged out"
      else
        session[:user_id] = nil
        flash[:success] = "Error: unknown user"
      end
    else
      flash[:error] = "You must be logged in to logout."
    end
    redirect_to root_path
  end

  def current
    @user = User.find_by(id: session[:user_id])

    if @user.nil?
      flash[:error] = "You must be logged in...."
      # change these lines???????
      redirect_to root_path
      return
    end
  end

  def index
    @users = User.order(created_at: :asc).all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Successfully created new user #{params[:user][:user_name]} with ID #{@user.id}"
      redirect_to root_path
    end
  end

  def show
    @user = User.find(params[:id])

    @works = []
    @user.votes.each do |vote|
      work = Work.find_by(id: vote.work_id)
      @works << work
    end

    # need to return in array like this???
    return [@user, @works]
  end

  private

  def user_params
    return params.require(:user).permit(:user_name)
  end
end