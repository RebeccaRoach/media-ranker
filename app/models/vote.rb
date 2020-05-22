class Vote < ApplicationRecord
  belongs_to :work
  belongs_to :user

  # validations here
end
