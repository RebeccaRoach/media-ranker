class HomepagesController < ApplicationController
  def index
    @top_ten_books = Work.top_ten('book')
    @top_ten_albums = Work.top_ten('album')
    @top_ten_movies = Work.top_ten('movie')
  end
end
