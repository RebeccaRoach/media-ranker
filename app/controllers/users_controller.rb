class UsersController < ApplicationController

  def index
    @users = User.order(created_at: :asc).all
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
end