require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to forgot_password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
         post :create, email: ''
         expect(flash[:danger]).to eq("Email cannot be blank")
      end
    end

    context "with existing email" do
      it "should redirect to the forgot_password confirmation page" do
        Fabricate(:user, email: "alice_in@wonderland.com")
        post :create, email: "alice_in@wonderland.com"
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "should send an email to the email address" do
        Fabricate(:user, email: "alice_in@wonderland.com")
        post :create, email: "alice_in@wonderland.com"
        expect(ActionMailer::Base.deliveries.last.to).to eq(["alice_in@wonderland.com"])
      end
    end

    context "with non-existant email" do
      it "redirects to the forgot password page" do
        post :create, email: "foo@example.com"
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        post :create, email: "foo@example.com"
        expect(flash[:danger]).to eql("Email not found")
      end
    end
  end
end
