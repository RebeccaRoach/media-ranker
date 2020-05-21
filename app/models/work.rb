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


  def most_recent_vote_date
    # returns most recent created_at date of votes
    votes = self.votes
    most_recent_date = Date.new(1965,5,20)

    votes.each do |vote|
      if vote.created_at > most_recent_date
        most_recent_date = vote.created_at
      end
    end

    return most_recent_date
  end


  def self.spotlight(category_name)
    # return single top work based on number of votes
    # or for tie, return the most recently upvoted work
    top_10 = self.top_ten(category_name)

    max_votes = 0
    ties = []

    top_10.each do |work|
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
