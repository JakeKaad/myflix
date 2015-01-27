require 'spec_helper'

describe ReviewsController do 

  describe 'POST create' do
    let(:video) { Fabricate(:video) }
    context "with authenticated users" do

      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context "with valid input" do 

        before do
           post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end

        it "redirects to the video show page" do 
          expect(response).to redirect_to video
        end

        it "should create a review" do 
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the signed in user" do 
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid input" do 

        before do
          post :create, review: {rating: 4}, video_id: video.id
        end

        it "doesn't create a review" do 
          expect(Review.count).to eq(0)
        end

        it "renders the videos/show template" do 
          expect(response).to render_template("videos/show")
        end

        it "sets the @video" do
          expect(assigns(:video)).to eq(video)
        end

        it "sets the @reviews" do
          review1 = Fabricate(:review, video: video)
          review2 = Fabricate(:review, video: video)
          post :create, review: {rating: 4}, video_id: video.id   
          expect(assigns(:reviews)).to match_array([review1, review2])
        end
      end
    end

    context "with unauthenticated users" do 
      it "redirects to the login page" do 
        post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        expect(response).to redirect_to login_path
      end
    end
  end
  
end 