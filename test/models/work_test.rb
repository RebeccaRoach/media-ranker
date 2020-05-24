require "test_helper"

describe Work do
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
      # vote fixture contains votes related to works
      @book1.votes.each do |vote|
        expect(vote).must_be_kind_of Vote
        expect(vote.work).must_equal @book1
        expect(vote.work_id).must_equal @book1.id
      end

      expect(@book1.votes.count).must_equal 3
    end

    it 'can also have 0 votes' do
      album_11 = works(:album_11)

      expect(album_11.votes.count).must_equal 0
    end
  end

  describe "Work#get_category" do

    it "can get all of the works of a certain category" do
      books_result = Work.get_category("book")
      albums_result = Work.get_category("album")

      books_result.each do |item|
        expect(item.category).must_equal "book"
      end

      albums_result.each do |item|
        expect(item.category).must_equal "album"
      end
      
      expect(books_result.count).must_equal 3
      expect(albums_result.count).must_equal 11
    end

    it "can get all of the works of a certain category in order from most to least votes" do
      # from fixtures expect order:
      # book1 with 3 votes, book2 with 2 votes, book3 with 0 votes

      result = Work.get_category("book")

      expect(result.count).must_equal 3

      expect(result[0]).must_equal works(:book_1)
      expect(result[0].votes.count).must_equal 3

      expect(result[1]).must_equal works(:book_2)
      expect(result[1].votes.count).must_equal 2


      expect(result[2]).must_equal works(:book_3)
      expect(result[2].votes.count).must_equal 0
    end

    it "returns nil if category is invalid" do
      invalid_result = Work.get_category("apricots")

      expect(invalid_result).must_be_nil
    end

    it "returns empty array if there are no works in a given category" do
      empty_result = Work.get_category("movie")

      expect(empty_result).must_equal []
    end

  end

  describe "Work#top_ten" do

    it "can get 10 works of a certain category" do
      top_albums = Work.top_ten("album")

      top_albums.each do |item|
        expect(item.category).must_equal "album"
      end
      
      expect(top_albums.count).must_equal 10
    end

    it "can get the top ten works of a certain category ordered from most to least votes" do
    #   # from fixtures expect order:
    #   # 2 with 3 votes, #3 with 2 votes, #4 with 2 votes, #5 with 2 votes, then 1 vote each for #1, #6, #7, #8, #9, #10

      result = Work.top_ten("album")

      expect(result.count).must_equal 10
      expect(result).wont_include works(:album_11)

      expect(result[0]).must_equal works(:album_2)
      expect(result[0].votes.count).must_equal 3

      expect(result[1]).must_equal works(:album_3)
      expect(result[1].votes.count).must_equal 2

      expect(result[9].votes.count).must_equal 1
    end

    it "returns empty array if category has no works" do
      invalid_result = Work.top_ten("movie")

      expect(invalid_result).must_equal []
    end

    it "returns all works if there are fewer than 10 works, in the right order" do
      fewer_than_10_works = Work.top_ten("book")

      expect(fewer_than_10_works.count).must_equal 3

      expect(fewer_than_10_works[0]).must_equal works(:book_1)
      expect(fewer_than_10_works[0].votes.count).must_equal 3

      expect(fewer_than_10_works[1]).must_equal works(:book_2)
      expect(fewer_than_10_works[1].votes.count).must_equal 2

      expect(fewer_than_10_works[2]).must_equal works(:book_3)
      expect(fewer_than_10_works[2].votes.count).must_equal 0
    end
  end

  describe "most_recent_vote_date" do
    it "returns the most recent date among multiple votes on a work" do
      
      test_work = works(:book_2)
      result = test_work.most_recent_vote_date

      expect(test_work.votes.count).must_equal 2
      expect(result).must_equal votes(:vote_5).created_at
    end

    it "returns nil if the work has no votes" do
      no_vote_work = works(:album_11)
      result = no_vote_work.most_recent_vote_date

      expect(result).must_be_nil
    end
  end

  describe "Work.spotlight" do
    it "returns the single top work based on highest number of votes" do
      # Fixtures have book_1 and album_2 each tied with 3 votes to begin
      expect(works(:album_2).votes.count).must_equal works(:book_1).votes.count

      # create a new vote for book_1
      Vote.create!(user: users(:penelope), work: works(:book_1))

      top_work = Work.spotlight
      expect(top_work).must_be_kind_of Work
      expect(top_work).must_equal works(:book_1)
    end

    it "returns the most recently upvoted work in the case of a tie for top work" do
      # Fixtures have book_1 and album_3 each with 3 votes to begin
      # set created_at values on book_1's votes to be in the past vs. album_2's votes created now
      vote_1 = votes(:vote_1)
      vote_1.created_at = "Fri, 22 May 2020 04:56:05 UTC +00:00"
      puts "VOTE CREATED AT: ::::::::: #{vote_1.created_at}"
      # puts "########"
      
      # puts "ALBUM 2 CREATED AT::::::::: #{votes(:vote_7).created_at}"
      # puts "ALBUM 2 CREATED AT::::::::: #{votes(:vote_16).created_at}"
      # puts "ALBUM 2 CREATED AT::::::::: #{votes(:vote_17).created_at}"
      # votes(:vote_2).created_at = "Fri, 22 May 2020 04:56:05 UTC +00:00"
      # votes(:vote_3).created_at = "Fri, 22 May 2020 04:56:05 UTC +00:00"
      # Fixtures.reload

      top_work_now = Work.spotlight
      puts "VOTE STILLLLLL CREATED AT: ::::::::: #{vote_1.created_at}"
      expect(top_work_now).must_be_kind_of Work
      expect(top_work_now).must_equal works(:album_2)
    end

    it "returns the first work in the database if there are no votes on any works" do
      Vote.destroy_all

      result = Work.spotlight
      expect(result).must_equal works(:book_1)
    end

    it "returns nil if no works are in the system" do
      Work.destroy_all
      expect(Work.spotlight).must_be_nil
    end
  end
end
