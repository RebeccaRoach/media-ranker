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
    end
  end

  describe 'relations' do
    it 'can have many votes' do

      # create 3 votes for this work_id
      # expect that the length of the array to be 3
        # (Work.votes).must_equal 3 
        # each of the three votes must be kind of vote



   
    end
  end
end
