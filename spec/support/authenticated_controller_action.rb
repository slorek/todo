require 'spec_helper'

shared_examples_for "an authenticated controller action" do |method, action|
  let(:user) { FactoryGirl.create(:user) }
  
  context "when signed out" do
    before { sign_out user }
    
    it "redirects to the sign in page" do
      send(method, action)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  
  context "when signed in" do
    before { sign_in user }
    subject { send(method, action) }
    
    it "does not redirect to the sign in page" do
      expect(subject).not_to redirect_to(new_user_session_path)
    end
  end
end
