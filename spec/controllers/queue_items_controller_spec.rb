require "spec_helper"

describe QueueItemsController do 

  describe "Get index" do 
    it "sets @Queue_items to the logged in user's queue items" do 
      jake = Fabricate(:user)
      set_current_user(jake)
      queue_item1 = Fabricate(:queue_item, user: jake)
      queue_item2 = Fabricate(:queue_item, user: jake)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it_behaves_like "require login" do 
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    context "With authenticated user" do 
      let(:joe) { Fabricate(:user)}
      let(:video) { Fabricate(:video) }
      before { set_current_user(joe) }

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
      it_behaves_like "require login" do 
        let(:action) { post :create, video_id: 1 }
      end
    end
  end

  describe "DELETE destroy" do 
    let(:joe) { Fabricate(:user) }
    let(:queue_item) { Fabricate(:queue_item, user: joe, position: 1) }
    before { set_current_user(joe) }

    it "redirects to the my_queue page" do
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "removes queue item from the queue" do 
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "does not remove queue item if it is not in current user's queue" do 
      alice = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it_behaves_like "require login" do 
      let(:action) { delete :destroy, id: 1 }
    end

    it "normalizes positions after a queue item is deleted" do 
      queue_item2 = Fabricate(:queue_item, user: joe, position: 2)
      delete :destroy, id: queue_item.id
      expect(queue_item2.reload.position).to eq(1)
    end
  end

  describe "POST update" do 
    context "with valid inputs" do 

      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video2) }

      before { set_current_user(alice) }
  
      it "redirects to the my_queue page" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.4}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 2}]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the positions" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do 

      let(:alice) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:video2) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2, video: video2) }

      before { set_current_user(alice) }

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.2}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets the flash error message" do 
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.2}, {id: queue_item2.id, position: 2}]
        expect(flash[:error]).to be_present
      end

      it "does not change the queue items" do
    
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2.1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated user" do
      it_behaves_like "require login" do 
        let(:action) { post :update_queue, queue_items: [{id: 1, position: 2}, {id: 2, position: 1}]}
      end
    end

    context "with queue items that do not belong to current user" do
      it "does not change the queue items" do 
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        video = Fabricate(:video)
        video2 = Fabricate(:video)
        set_current_user(alice) 
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2, video: video2)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 2}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end