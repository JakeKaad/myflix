require 'spec_helper'

describe SessionsController do 

  describe 'GET login' do
    it 'should redirect to home for authenticated users' do 
      session[:user_id] = Fabricate(:user).id 
      get :new 
      expect(response).to redirect_to home_path
    end

    it 'should render login form for unauthenticated users' do 
      get :new 
      expect(response).to render_template(:new)
    end
  end

  describe 'POST login' do 
    let(:alice) { Fabricate(:user) }

    context "With valid credentials" do

      before do
        post :create, email: alice.email, password: alice.password
      end

      it "puts the user into the session" do
        expect(session[:user_id]).to eq(alice.id)
      end

      it "redirects to home page" do 
        expect(response).to redirect_to home_path
      end

      it "sets notice" do 
        expect(flash[:info]).not_to be_blank
      end
    end


    context "with invalid credentials" do

      before do 
        post :create, email: alice.email, password: alice.password + "12345"
      end

      it "does not put logged in user into the session" do
         expect(session[:user_id]).to be_blank
      end

      it "redirects to the login page" do 
        expect(response).to redirect_to login_path
      end

      it "sets the error message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe 'GET destroy' do

    before do 
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "clears the session of the user_id" do 
      expect(session[:user_id]).to be_blank
    end

    it "redirects to root" do 
      expect(response).to redirect_to root_path
    end

    it "sets the notice" do
      expect(flash[:info]).not_to be_blank
    end
  end
end