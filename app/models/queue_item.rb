class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

delegate :category, to: :video
delegate :title, to: :video, prefix: :video
delegate :name, to: :category, prefix: :category

  def rating 
    review = user.reviews.find_by(video_id: self.video.id)
    review.rating if review
  end
end