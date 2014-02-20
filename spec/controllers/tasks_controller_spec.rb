require 'spec_helper'

describe TasksController do
  describe "#index" do
    it_should_behave_like "an authenticated controller action", :get, :index
  end
  
  describe "#create" do
    let(:params) do
      { 'task' => { 'name' => 'test' } }
    end
    
    it_should_behave_like "an authenticated controller action", :post, :create
    
    context "when signed in" do
      
      let(:user) { FactoryGirl.create(:user) }
      
      before { sign_in user }
      
      it "injects the current user to the supplied params when creating a Task instance" do
        expect(Task).to receive(:new).with({ 'name' => 'test', 'user_id' => user.id }).and_return(double('foo').as_null_object)
        post :create, params
      end
      
      it "saves the Task instance" do
        expect_any_instance_of(Task).to receive(:save)
        post :create, params
      end
      
      context "with valid parameters" do
        it "redirects to tasks_path" do
          post :create, params
          expect(response).to redirect_to(tasks_path)
        end
      end
      
      context "with invalid parameters" do
        let(:params) do
          { 'task' => {} }
        end
        
        it "renders the #index view" do
          post :create, params
          expect(response).to render_template(:index)
        end
      end
    end
  end
end
