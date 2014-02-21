require 'spec_helper'

shared_examples_for "an authenticated controller action" do |method, action|
  before { @user ||= FactoryGirl.create(:user) }
  
  describe "session authentication" do
    context "when signed out" do
      before { sign_out @user }
    
      it "redirects to the sign in page" do
        send(method, action, params)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  
    context "when signed in" do
      before { sign_in @user }
      subject { send(method, action, params) }
    
      it "does not redirect to the sign in page" do
        expect(subject).not_to redirect_to(new_user_session_path)
      end
    end
  end
end
