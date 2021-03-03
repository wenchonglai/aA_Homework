require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "should render the new template" do
      get :new, {}
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with existing username" do
      it "should save errors to flash and render the new template" do
        post :create, params: {user: {email: "1@2.com", password: "testingtesing"}}
        expect(flash[:errors]).to include "Email has already been taken"
        expect(response).to render_template(:new)
      end
    end
    
    context "with invalid params" do
      it "should save errors to flash and render the new template" do
        post :create, params:{user: {email: "777777@77.com", password: "1234"}}
        expect(flash[:errors]).to include "Password is too short (minimum is 6 characters)"
        expect(response).to render_template(:new)
      end
    end

    context "with invalid params" do
      it "should save errors to flash and render the new template" do
        post :create, params:{user: {email: "1234", password: "1234567"}}
        expect(flash[:errors]).to include "Email must comply with the correct format"
        expect(response).to render_template(:new)
      end
    end

    context "with no params" do
      it "should render the new template" do
        expect{post :create, {}}.to raise_error
      end
    end

    context "with valid params" do
      before(:each){post :create, params: {user: {email: "test123456@testing.com", password:"testingtesing"}}}

      it "should not have any error messages" do
        expect(flash[:error]).to be nil
      end

      it "should redirect to root" do
        expect(response).to redirect_to(:root)
      end
    end
  end
end
