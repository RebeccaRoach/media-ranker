class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  # GET /works
  def index
    @works = Work.all
  end

  # GET /works/1
  def show
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
    @work.destroy
    head :no_content
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
