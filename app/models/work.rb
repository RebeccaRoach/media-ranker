class Work < ApplicationRecord
  has_many :votes

  # has_many :users, through: :votes

  # class method to sort by max votes

  def self.get_category(category_name)
    return self.where(category: category_name)
  end

  def self.top_ten(category_name)
    # find the top 10 works in a category that have the most descending votes
    # any tie breaking logic required??
    return self.get_category(category_name).max_by(10) {
      |work| work.votes.count
    }
  end

end
