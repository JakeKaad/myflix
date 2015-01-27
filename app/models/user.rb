class User < ActiveRecord::Base
  
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: {minimum: 6}, on: :create
  validates_confirmation_of :password, on: :create
  validates_presence_of :full_name
	has_secure_password

end