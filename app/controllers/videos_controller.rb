class VideosController < ApplicationController
  before_action :require_user
  before_action :set_video, only: [:show]

  def index
    @categories = Category.all
    @videos = Video.all
  end

  def show
<<<<<<< HEAD
    @review = Review.new
    @reviews = @video.reviews
=======
>>>>>>> origin/master
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end 


  private 

    def set_video
      @video = Video.find(params[:id])  
    end

end