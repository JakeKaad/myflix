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

  describe "POST create" do
    context "With authenticated user" do 
      let(:joe) { Fabricate(:user)}
      let(:video) { Fabricate(:video) }
      before do 
        session[:user_id] = joe.id
      end

      it "redirects to the my_queue page" do
        post :create, video_id: video.id 
        expect(response).to redirect_to my_queue_path
      end

      it "creates the queue item" do
        post :create, video_id: video.id 
        expect(QueueItem.count).to eq(1)
      end

      it "creates the queue item that is associated with the video" do 
        post :create, video_id: video.id  
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates the queue item that is associated with the current user"  do 
        post :create, video_id: video.id
        expect(QueueItem.first.user).to eq(joe)
      end

      it "puts the video last in queue" do 
        monk = Fabricate(:video)
        queueitem2 = Fabricate(:queue_item, video: monk, user: joe)
        post :create, video_id: video.id 
        expect(QueueItem.last.position).to eq(2)
      end

      it "does not duplicate the same video in the queue" do 
        monk = Fabricate(:video)
        queueitem2 = Fabricate(:queue_item, video: monk, user: joe)
        post :create, video_id: monk.id 
        expect(joe.queue_items.count).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the sign in for unauthenticated users" do 
        video = Fabricate(:video)
        post :create, video_id: video.id
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "DELETE destroy" do 
    it "redirects to the my_queue page" do
      joe = Fabricate(:user)
      session[:user_id] = joe.id  
      queue_item = Fabricate(:queue_item, user: joe)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "removes queue item from the queue" do 
      joe = Fabricate(:user)
      session[:user_id] = joe.id  
      queue_item = Fabricate(:queue_item, user: joe)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "does not remove queue item if it is not in current user's queue" do 
      joe = Fabricate(:user)
      alice = Fabricate(:user)
      session[:user_id] = joe.id  
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects unauthenticated user to signin path" do 
      delete :destroy, id: 3 
      expect(response).to redirect_to login_path
    end
  end
end