class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :user

  delegate :title, to: :video, prefix: :video

  validates_presence_of :content, :rating
end