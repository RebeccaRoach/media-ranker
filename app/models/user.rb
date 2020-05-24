class User < ApplicationRecord
  has_many :votes

  validates :user_name, presence: true
end
