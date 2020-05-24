require "test_helper"

describe User do

  it "can be instantiated successfully" do
    user = User.create!(user_name: "Awesome User Name")
  
    expect(user.valid?).must_equal true
  end

  describe "validations" do
    before do
      @penelope = users(:penelope)
    end

    it 'is valid when a title is present' do
      result = @penelope.valid?

      expect(result).must_equal true
    end

    it 'is invalid without a user_name' do
      @penelope.user_name = nil
      
      expect(@penelope.valid?).must_equal false
      expect(@penelope.errors.messages).must_include :user_name
      expect(@penelope.errors.messages[:user_name]).must_equal ["can't be blank"]
    end
  end

  describe "relations" do
    let (:user) {
      users(:edgar)
    }

    it 'can have many votes' do
      user.votes.each do |vote|
        expect(vote).must_be_kind_of Vote
        expect(vote.user).must_equal user
        expect(vote.user_id).must_equal user.id
      end

      expect(user.votes.count).must_equal 12
    end

    it 'can also have 0 votes' do
      no_votes_user = users(:penelope)

      Vote.all.each do |vote|
        expect(vote.user_id).wont_equal no_votes_user.id
      end

      expect(no_votes_user.votes.count).must_equal 0
    end
  end
end
