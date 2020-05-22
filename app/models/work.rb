class Work < ApplicationRecord
  has_many :votes
  
  validates :title, presence: true

  # has_many :users, through: :votes

  # class method to sort by max votes

  def self.get_category(category_name)
    return self.where(category: category_name)
  end

end
