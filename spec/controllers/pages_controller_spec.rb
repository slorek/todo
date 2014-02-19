require 'spec_helper'

describe PagesController do

  describe "#index" do
    let(:user) { FactoryGirl.create(:user) }
    
    context "when signed out" do
      before { sign_out user }
      
      it "renders the view template" do
        get :index
        expect(response).to render_template("index")
      end
    end
    
    context "when signed in" do
      before { sign_in user }
      subject { get :index }
      
      it "redirects to tasks_path" do
        expect(subject).to redirect_to(tasks_path)
      end
    end
  end
end
