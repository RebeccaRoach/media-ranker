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
      flash[:success] = "Welcome #{@user.user_name}!"
    else
      # existing user
      flash[:success] = "Successfully logged in as existing user #{@user.user_name}"
    end

    # finally, set the session id for the new or existing user
    session[:user_id] = @user.id
    redirect_to root_path
  end

  # def logout
  #   if session[:user_id]

  #   else

  #   end
  # end

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
    # do something if save fails?
  end

  def show
    # use find so it won't try to go to the user show view and throw error instead
    @user = User.find(params[:id])

    # return @works so that we can easily access a user's voted works in the show view
    @works = []
    @user.votes.each do |vote|
      work = Work.find_by(id: vote.work_id)
      @works << work
    end

    return [@user, @works]
  end

  private

  def user_params
    return params.require(:user).permit(:user_name)
  end
end