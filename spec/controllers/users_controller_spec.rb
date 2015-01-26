require 'spec_helper'

describe UsersController do 

  describe "GETs new" do 
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

  end
end