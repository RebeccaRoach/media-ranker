require "test_helper"

describe Work do

  # 1+ test for each validation (all pass, some pass, none pass)
  #     validates title: presence: true
  # 1+ test for each relation (has many votes)
  # 1+ test for each custom method on work model

  describe 'validations' do
    before do
      @book1 = works(:book_1)
    end

    it 'is valid when all fields are present' do
      result = @book1.valid?

      expect(result).must_equal true
    end

    it 'is valid when not every field is present' do

      some_field_params = {
        category: 'book',
        title: 'A book with some title',
        publication_year: 1995
      }

      book_some_fields = Work.new(some_field_params)

      expect(book_some_fields.valid?).must_equal true
    end

    it 'is invalid without a title' do
      @book1.title = nil
      
      expect(@book1.valid?).must_equal false
      expect(@book1.errors.messages).must_include :title
      expect(@book1.errors.messages[:title]).must_equal ["can't be blank"]
    end
  end

  describe 'relations' do
    before do
      @book1 = works(:book_1)
    end

    it 'can have many votes' do
    
      @book1.votes.each do |vote|
        expect(vote).must_be_kind_of Vote
        expect(vote.work).must_equal @book1
        expect(vote.work_id).must_equal @book1.id
      end

      expect(@book1.votes.count).must_equal 3
    end

    it 'can also have 0 votes' do
      album_1 = works(:album_1)

      expect(album_1.votes.count).must_equal 0
    end
  end


# TEST NOMINAL/EDGE cases for these four methods:

  # def self.get_category(category_name)

  #   num_category_works = self.where(category: category_name).count

  #   return self.where(category: category_name).max_by(num_category_works) {
  #     |work| work.votes.count
  #   }
  # end

  # def self.top_ten(category_name)
  #   # find the top 10 works in a category that have the most descending votes
  #   # any tie breaking logic required??
  #   return self.get_category(category_name).max_by(10) {
  #     |work| work.votes.count
  #   }
  # end

  # def most_recent_vote_date
  #   # returns most recent created_at date of votes
  #   votes = self.votes
  #   most_recent_date = Date.new(1965,5,20)

  #   votes.each do |vote|
  #     if vote.created_at > most_recent_date
  #       most_recent_date = vote.created_at
  #     end
  #   end

  #   return most_recent_date
  # end


  # def self.spotlight
  #   # return single top work based on number of votes
  #   # or for tie, return the most recently upvoted work
  #   all_works = Work.all

  #   max_votes = 0
  #   ties = []

  #   all_works.each do |work|
  #     if work.votes.count == max_votes
  #       ties << work
  #     elsif work.votes.count > max_votes
  #       ties = [work]
  #       max_votes = work.votes.count
  #     end
  #   end

  #   if ties.length > 1
  #     return ties.max_by {|work| work.most_recent_vote_date }
  #   else
  #     return ties[0]
  #   end

  # end
end
