require 'spec_helper'

describe User do

  it { should have_secure_password }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of :full_name }
  it { should have_many(:queue_items).order(:position) }
  it { should have_many(:reviews).order("created_at DESC") }

  it "generates a random token when the user is created" do
    alice = Fabricate(:user)
    expect(alice.token).to be_present
  end
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

  describe "#follows?" do
    it "returns true if the user has a following_relationship with the leader" do
      alice = Fabricate(:user)
      jane = Fabricate(:user)
      Fabricate(:relationship, leader_id: jane.id, follower_id: alice.id)
      expect(alice.follows?(jane)).to be_truthy
    end

    it "returns false if the user doesn't have a following_relationship with the leader" do
      alice = Fabricate(:user)
      jane = Fabricate(:user)
      Fabricate(:relationship, leader_id: jane.id, follower_id: Fabricate(:user).id)
      expect(alice.follows?(jane)).to be_falsey
    end
  end
end
