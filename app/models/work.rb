class Work < ApplicationRecord
  has_many :votes, dependent: :destroy
  
  validates :title, presence: true
  validates :category, presence: true
  validates_uniqueness_of :title, scope: :category, message: "has already been taken"

  # has_many :users, through: :votes


  def self.get_category(category_name)
    valid_categories = ["album", "book", "movie"]
    return nil if !valid_categories.include?(category_name)

    num_category_works = self.where(category: category_name).count

    return self.where(category: category_name).max_by(num_category_works) {
      |work| work.votes.count
    }
  end

  def self.top_ten(category_name)
    return self.get_category(category_name)[0..9]
  end

  def most_recent_vote_date
    # returns most recent created_at date of votes
    votes = self.votes
    most_recent_date = Date.new(1965,5,20)
    return most_recent_date if votes.count == 0

    votes.each do |vote|
      if vote.created_at > most_recent_date
        most_recent_date = vote.created_at
      end
    end

    return most_recent_date
  end


  def self.spotlight
    # return single top work based on number of votes
    # or for tie, return the most recently upvoted work
    all_works = Work.all

    max_votes = 0
    ties = []

    all_works.each do |work|
      if work.votes.count == max_votes
        ties << work
      elsif work.votes.count > max_votes
        ties = [work]
        max_votes = work.votes.count
      end
    end

    if ties.length > 1
      return ties.max_by {|work| work.most_recent_vote_date }
    else
      return ties[0]
    end

  end
end
