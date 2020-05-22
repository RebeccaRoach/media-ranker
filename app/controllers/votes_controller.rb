class VotesController < ApplicationController


  # def new
  #   vote = Vote.new
  # end

  # def create
  #   new_params = Vote.upvote
  #   if new_params[:user_id].nil?
  #     flash.now[:error] = "A problem occurred: You must log in to do that"
  #     redirect_to works_path(new_params[:work_id])
  #     return
  #   end
  #   vote = Vote.new(new_params)
    
  #   if vote.save
  #     flash[:success] = "Successfully upvoted!"
  #     redirect_to works_path(new_params[:work_id])
  #   else
  #     flash.now[:error] = "There was an error for some reason!!"
  #     redirect_to works_path(new_params[:work_id])
  #   end
  # end

  # def destroy
  #   @vote = Vote.find_by(id: params[:id])
  #   @vote.destroy
  #   return
  # end

end
