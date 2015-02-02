require 'spec_helper'

describe QueueItem do 
  it { should belong_to :video }
  it { should belong_to :user }
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do 
    it "returns the title of associated video" do 
      video = Fabricate(:video, title: 'gotham') 
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('gotham')
    end

    describe "#rating" do 
      let(:video) { Fabricate(:video) }
      let(:user) { Fabricate(:user) }
      let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }

      it "returns the rating from the review when the review is present" do 
        review = Fabricate(:review, user: user, video: video, rating: 2)
        expect(queue_item.rating).to eq(2) 
      end

      it "returns nil when the review isn't present" do 
        expect(queue_item.rating).to be_nil
      end
    end

    describe "#rating=" do 
      it "changes the rating from the review when the rating is present" do 
        video = Fabricate(:video)
        user = Fabricate(:user)
        review = Fabricate(:review, user: user, video: video, rating: 2)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rating = 4
        expect(Review.first.rating).to eq(4)
      end

      it "can clear the rating from the review if the rating is present" do 
        video = Fabricate(:video)
        user = Fabricate(:user)
        review = Fabricate(:review, user: user, video: video, rating: 2)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rating = nil
        expect(Review.first.rating).to be_nil
      end

      it "creates a review with the rating if the review is not present" do 
         video = Fabricate(:video)
        user = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: user, video: video)
        queue_item.rating = 4
        expect(Review.first.rating).to eq(4)
      end
    end

    describe "#category_name" do 
      it "returns the name of associated video's category" do
        action = Category.create(name: "Action")
        video = Fabricate(:video, category: action)
        queue_item = Fabricate(:queue_item, video: video)
        expect(queue_item.category_name).to eq("Action")
      end
    end

    describe "#category" do 
      it "returns the associated video's category" do
        action = Category.create(name: "Action")
        video = Fabricate(:video, category: action)
        queue_item = Fabricate(:queue_item, video: video)
        expect(queue_item.category).to eq(action)
      end
    end
  end
end
