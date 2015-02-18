class User < ActiveRecord::Base
  has_many :queue_items, -> { order(:position) }
  has_many :reviews
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}, on: :create
  validates_confirmation_of :password, on: :create
  validates_presence_of :full_name
	has_secure_password

  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

end