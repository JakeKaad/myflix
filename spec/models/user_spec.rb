require 'spec_helper'

describe User do

  it { should have_secure_password }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of :full_name }
  it { should have_many(:queue_items).order(:position) }

  describe  "#queued_video" do 
    it "returns true when the user queued the video" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_truthy
    end
    it "returns false when the user hasn't queued the video" do 
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be_falsey
    end
  end
end