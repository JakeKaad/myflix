require "spec_helper"

describe QueueItemsController do 

  describe "Get index" do 
    it "sets @Queue_items to the logged in user's queue items" do 
      jake = Fabricate(:user)
      session[:user_id] = jake.id
      queue_item1 = Fabricate(:queue_item, user: jake)
      queue_item2 = Fabricate(:queue_item, user: jake)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to the login page if user is unauthenticated" do 
      get :index
      expect(response).to redirect_to login_path
    end
  end
end