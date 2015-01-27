require 'spec_helper'

describe Category do 
  it { should have_many(:videos)}

  describe "#recent_videos" do 
    it "returns an empty array if the category has no videos in it" do
      drama = Category.create(name: "drama")
      expect(drama.recent_videos).to eq([])
    end

    it "returns all videos in category if there are less than 6" do
      drama = Category.create(name: "drama")
      monk =  Video.create(title: "monk", description: "Sample Video", category: drama, created_at: 1.day.ago )
      gotham =  Video.create(title: "gotham", description: "Sample Video", category: drama )
      expect(drama.recent_videos).to eq([gotham, monk])
    end

    it "returns all videos in category if there are less than 6" do
      drama = Category.create(name: "drama")
      monk =  Video.create(title: "monk", description: "Sample Video", category: drama, created_at: 1.day.ago )
      gotham =  Video.create(title: "gotham", description: "Sample Video", category: drama )
      expect(drama.recent_videos.count).to eq(2)
    end

    it "returns 6 videos if there are more than 6 videos" do
      drama = Category.create(name: "drama")
      7.times { Video.create(title: "test", description: "test", category: drama)}
      expect(drama.recent_videos.count).to eq(6)
    end

    it "returns the 6 most recently created videos ordered reverse chronologically" do 
      drama = Category.create(name: "drama")
      6.times { Video.create(title: "test", description: "test", category: drama)}
      gotham =  Video.create(title: "gotham", description: "Sample Video", category: drama, created_at: 1.day.ago )
      expect(drama.recent_videos).not_to include(gotham)
    end
  end
 end 
