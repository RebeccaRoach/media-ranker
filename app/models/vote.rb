class Vote < ApplicationRecord
  belongs_to :work
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :work_id
end
