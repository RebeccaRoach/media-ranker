require "test_helper"

describe Vote do

  describe 'relations' do
    before do 
      @user = users(:helen)
      @work = works(:album_6)
      @vote = Vote.create(user: @user, work: @work)
    end

    it 'can access the work and the user through vote' do
      expect(@vote.user_id).must_equal @user.id
      expect(@vote.work_id).must_equal @work.id
    end

    it 'can set the work and the user through vote' do
      work = Work.create!(category: 'movie', title: 'Dead Poets Society')
      user = User.create!(user_name: 'John Keating')
      another_vote = Vote.new(user_id: 83740, work_id: 53245)

      another_vote.user_id = user.id
      another_vote.work_id = work.id

      expect(another_vote.user_id).must_equal user.id
      expect(another_vote.work_id).must_equal work.id
    end
  end

  describe 'validations' do
    before do
      @vote_1 = votes(:vote_1)
    end

    it 'is valid when all fields are present' do
      result = @vote_1.valid?

      expect(result).must_equal true
    end

    it "can be instantiated successfully for existing users and works" do
      new_user = User.create!(user_name: "Ronda")
      new_work = Work.create!(title: "Ronda and Dog: A Not So Still Life")
      new_vote = Vote.create!(user: new_user, work: new_work)
    
      expect(new_vote.valid?).must_equal true
      expect(new_work.votes.count).must_equal 1
      expect(new_vote.user).must_equal new_user
      expect(new_vote.user_id).must_equal new_user.id
    end
  
    it "is not a valid vote if user/user_id is invalid" do
      previous_vote_count = Vote.all.count
      
      invalid_id = -1
      attempted_vote = Vote.new(user_id: invalid_id, work_id: 2)
      result = attempted_vote.save
  
      expect(result).must_equal false
      expect(Vote.all.count).must_equal previous_vote_count
    end

    it "is not a valid vote if user/user_id is missing" do
      previous_vote_count = Vote.all.count
      
      attempted_vote = Vote.new(work_id: 2)
      result = attempted_vote.save
  
      expect(result).must_equal false
      expect(Vote.all.count).must_equal previous_vote_count
    end
  
    it "is not a valid vote if work/work_id is invalid" do
      previous_vote_count = Vote.all.count
      
      invalid_id = -1
      attempted_vote = Vote.new(user_id: 1, work_id: invalid_id)
      result = attempted_vote.save
  
      expect(result).must_equal false
      expect(Vote.all.count).must_equal previous_vote_count
    end

    it "is not a valid vote if work/work_id is missing" do
      previous_vote_count = Vote.all.count
      
      attempted_vote = Vote.new(user_id: 1)
      result = attempted_vote.save
  
      expect(result).must_equal false
      expect(Vote.all.count).must_equal previous_vote_count
    end

    it "is invalid for a user to vote more than once on the same work" do
      # Fixtures define a vote for helen on book_1 already
      previous_book_1_votes = works(:book_1).votes.count
      vote_1 = votes(:vote_1)
      expect(vote_1.user).must_equal users(:helen)
      expect(vote_1.work).must_equal works(:book_1)

      # Attempt to make a vote for helen on book_1 again
      attempted_vote = Vote.new(user: users(:helen), work: works(:book_1))
      result = attempted_vote.save

      expect(result).must_equal false
      # expect(attempted_vote.errors.messages[:user]).must_include "has already voted for this work"
      expect(works(:book_1).votes.count).must_equal previous_book_1_votes
    end
  end
end