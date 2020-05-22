class Vote < ApplicationRecord
  belongs_to :work
  belongs_to :user

  def self.upvote(work_id)
    # get user_id from session
    user = User.find_by(id: session[:user_id])
    # ^^ equivalent to: user_id = session[:user_id] ???
    
    # create a new vote for this user, for this work
    Vote.create(user_id: user.id, work_id: work_id)
    flash.now[:success] = "Successfully upvoted!"
  end
end
