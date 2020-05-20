class Vote < ApplicationRecord
  belongs_to :work
  belongs_to :user

  def self.upvote
    
  end
end
