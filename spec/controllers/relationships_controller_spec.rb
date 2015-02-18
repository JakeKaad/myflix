require 'spec_helper'

describe RelationshipsController do 
  describe 'GET index' do 
    it "sets @relationships to current user's following relationships" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      jane = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice, leader: jane)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "require login" do 
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do 
    let(:alice) { Fabricate(:user) }
    let(:jane) { Fabricate(:user) }
    let(:relationship) { Fabricate(:relationship, follower: alice, leader: jane)  }

    before  do 
      set_current_user(alice) 
    end

    it "redirects to the people page" do 
      delete :destroy, id: relationship.id 
      expect(response).to redirect_to people_path
    end

    it "sets @relationships to current user's following relationships" do 
      delete :destroy, id: relationship.id
      expect(assigns(:relationship)).to eq(relationship)
    end

    it "deletes the relationship if the current user is the follower in that relationship" do 
      delete :destroy, id: relationship.id 
      expect(Relationship.all).to be_empty
    end

    it "doesn't delete the relationship if the current user is not the follower" do 
      set_current_user(jane)
      delete :destroy, id: relationship.id 
      expect(Relationship.all.length).to eq(1)
    end
  end
end