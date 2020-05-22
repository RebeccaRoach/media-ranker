class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  def index
    # show all works by max votes and descending
    # if a tie, most recent voted goes first
    
    @books = Work.get_category("book")
    @movies = Work.get_category("movie")
    @albums = Work.get_category("album")
   
  end

  def show
    @work = Work.find(params[:id])

    # need to be able to return all the users who voted for single work
    # ordered by most recently voted on that work

    @users = []
    @work.votes.each do |vote|
      user = vote.user
      @users << user
    end

    # check if i need this return
    return [@work, @users]
  end

  def new
    @work = Work.new
  end

  def edit
  end

  def create
    @work = Work.new(work_params)

    if @work.save
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
      redirect_to @work
    else
      flash[:error] = "A problem occurred: Could not create #{@work.category}"
      flash[:error_messages] = @work.errors.messages
      render :new
    end
  end

  def update
    if @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}"
      redirect_to @work
    else
      flash[:error] = "A problem occurred: Could not update #{@work.category}"
      flash[:error_messages] = @work.errors.messages
      render :edit
    end
  end

  def destroy
    @work = Work.find(params[:id])
    if @work.nil?
      redirect_to root_path, notice: 'Work not found'
      return
    end

    @work.destroy
    redirect_to root_path
    flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}"
    return
  end

  def upvote
    # get user_id from session
    user = User.find_by(id: session[:user_id])
    # ^^ equivalent to: user_id = session[:user_id] ???

    # call User#current here
    if user.nil?
      # might need new structure below:
      flash[:error] = "A problem occurred: You must log in to do that"
      redirect_to work_path(params[:id])
      return
    end
    # create a new vote for this user, for this work
    vote = Vote.new(user_id: user.id, work_id: params[:id])

    if vote.save
      flash[:success] = "Successfully upvoted!"
      redirect_to work_path(params[:id])
    else

      flash[:error] = "A problem occurred: Could not upvote"
      flash[:error_messages] = vote.errors.messages
      redirect_to work_path(params[:id])
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work
      @work = Work.find(params[:id])
    end

    def work_params
      params.require(:work).permit(:title, :creator, :publication_year, :description, :category)
    end
end
