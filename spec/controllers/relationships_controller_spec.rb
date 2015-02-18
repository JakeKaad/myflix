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
end