class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  # GET /works
  def index
    @works = Work.all
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

    return [@work, @users]
  end

  # GET /works/new
  def new
    @work = Work.new
  end

  # GET /works/1/edit
  def edit
  end

  # POST /works
  def create
    @work = Work.new(work_params)

    if @work.save
      redirect_to @work, notice: 'Work was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /works/1
  def update
    if @work.update(work_params)
      redirect_to @work, notice: 'Work was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /works/1
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work
      @work = Work.find(params[:id])
    end

    def work_params
      params.require(:work).permit(:title, :creator, :publication_year, :description, :category)
    end
end
