require 'spec_helper'

describe UsersController do 

  describe "GET new" do 
    it 'sets @user' do 
      get :new 
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do 

    context "with valid input" do
      before { post :create, user: Fabricate.attributes_for(:user) }

      it "creates the user" do 
        expect(User.count).to eq(1)
      end
      it "redirects to home page" do 
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid input" do 

      before { post :create, user: { full_name: "test name", password: 'password'} } 

      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it "renders new template" do
        post :create, user: { full_name: "test name", password: 'password'}
        expect(response).to render_template(:new)
      end
      it "sets @user" do 
        post :create, user: { full_name: "test name", password: 'password'}
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
    
    context "sending emails" do 
      it "sends out an email to the user with valid inputs" do 
        post :create, user: {email: "alice_in@wonderland.com", password: 'password', full_name: "Alice White"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["alice_in@wonderland.com"])
      end
      it "sends out an email containing the user's name with valid inputs"
      it "does not send out an email with invalid inputs"
    end
  end



  describe "GET show" do 
    it 'sets @user correctly' do 
      alice = Fabricate(:user)
      joe = Fabricate(:user)
      set_current_user(joe)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it "redirects if current user not logged in" do 
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(response).to redirect_to login_path
    end

    it "sets @queue_items to @user's queue_items" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :show, id: alice.id
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "sets @reviews to @user's reviews" do 
      alice = Fabricate(:user)
      set_current_user(alice)
      review1 = Fabricate(:review, user: alice)
      review2 = Fabricate(:review, user: alice)
      get :show, id: alice.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

  end
end