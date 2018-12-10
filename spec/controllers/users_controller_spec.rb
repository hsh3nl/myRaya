require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    let( :valid_params )          { { user: { first_name: 'Mr', last_name: 'Test', email:'mrtest@tester.com', gender:'Male', tel_no:'018-5678932', password:'12345', password_confirmation:'12345' }} }
    let( :invalid_params )        { { user: { last_name: 'Test', email:'mrtest.tester.com', gender:'', tel_no:'018-5678932', password:'12345', password_confirmation:'1234' }} }

    context "when valid params" do
      it "should save user" do
        post :create, params: valid_params
        expect(User.find_by({ first_name: 'Mr', last_name: 'Test', email:'mrtest@tester.com', gender:'Male', tel_no:'018-5678932'})).not_to eq nil
        expect(flash[:notice]).to eq nil
        expect(flash[:success]).not_to eq nil
      end

      it "should redirect to sessions#new" do
        post :create, params: valid_params
        expect(response).to redirect_to( sign_in_path )
      end
    end

    context "when invalid params" do
      it "should re-render submission page" do
        post :create, params: invalid_params
        expect(User.find_by({last_name: 'Test', email:'mrtest.tester.com', gender:'', tel_no:'018-5678932'})).to eq nil
        expect(response).to redirect_to( sign_up_path )
      end

      it "should render with generated errors in @errors" do
        post :create, params: invalid_params
        expect(flash[:notice]).not_to eq nil
        expect(flash[:success]).to eq nil
      end
    end
  end
end
