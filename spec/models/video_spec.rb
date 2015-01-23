require 'spec_helper'

describe Video do 
  it "saves itself" do
    video = Video.new(title: "Gotham", description: "batman!")
    video.save
    expect(Video.first).to eq(video)
  end

end