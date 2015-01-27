class ReviewsController < ApplicationController

  before_action :require_user, only: [:create]

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(params.require(:review).permit(:rating, :content).merge!(user: current_user))

    if @review.save
      flash[:notice] = "Review submitted"
      redirect_to @video
    else
      @reviews = @video.reviews.reload
      flash[:error] = "Review not save due to missing content"
      render "videos/show"
    end
  end

end