require 'spec_helper'

describe TasksController do
  
  let(:params) { Hash.new }
  
  describe "#index" do
    it_should_behave_like "an authenticated controller action", :get, :index
    it_should_behave_like "an authenticated API controller action", :get, :index
  end
  
  describe "#create" do
    let(:params) do
      { 'task' => { 'name' => 'test' } }
    end
    
    it_should_behave_like "an authenticated controller action", :post, :create
    it_should_behave_like "an authenticated API controller action", :post, :create
    
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
        context "with HTML request" do
          it "redirects to tasks_path" do
            post :create, params
            expect(response).to redirect_to(tasks_path)
          end
        end
        
        context "with JSON request" do
          before { params['format'] = 'json' }
          
          it "returns 201 status" do
            post :create, params
            expect(response.status).to eq(201)
          end
        end
      end
      
      context "with invalid parameters" do
        let(:params) do
          { 'task' => {} }
        end
        
        context "with HTML request" do
          it "renders the #index view" do
            post :create, params
            expect(response).to render_template(:index)
          end
        end
        
        context "with JSON request" do
          before { params['format'] = 'json' }

          it "returns 422 status" do
            post :create, params
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end
  
  describe "#destroy" do
    let(:task) { FactoryGirl.create :task }
    let(:params) { { 'id' => task.id } }
    
    before { @user = task.user }
    
    it_should_behave_like "an authenticated controller action", :delete, :destroy
    it_should_behave_like "an authenticated API controller action", :delete, :destroy
    
    context "when signed in" do
      
      before { sign_in @user }
      
      context "with a valid task ID parameter" do
        it "calls #destroy on the Task instance" do
          expect_any_instance_of(Task).to receive(:destroy)
          delete :destroy, params
        end
      end

      context "with JSON request" do
        before { params['format'] = 'json' }

        it "returns 204 status" do
          delete :destroy, params
          expect(response.status).to eq(204)
        end
      end
    
      context "with invalid parameters" do
        let(:params) { { 'id' => 'dsfsdsdf' } }
      
        it "throws an ActionController::RoutingError" do
          expect(->{ delete :destroy, params }).to raise_error(ActionController::RoutingError)
        end
      end
    end
  end

  describe "#completed" do
    let(:task) { FactoryGirl.create :task }
    let(:params) { { 'id' => task.id } }
    
    before { @user = task.user }
    
    it_should_behave_like "an authenticated controller action", :patch, :completed
    it_should_behave_like "an authenticated API controller action", :patch, :completed
    
    context "when signed in" do
      
      before { sign_in @user }
      
      context "with a valid task ID parameter" do
        it "sets completed_at on the Task instance" do
          patch :completed, params
          task.reload
          expect(task.completed?).to eq(true)
        end
      end
      
      context "with JSON request" do
        before { params['format'] = 'json' }

        it "returns 204 status" do
          patch :completed, params
          expect(response.status).to eq(204)
        end
      end
    
      context "with invalid parameters" do
        let(:params) { { 'id' => 'dsfsdsdf' } }
      
        it "throws an ActionController::RoutingError" do
          expect(->{ patch :completed, params }).to raise_error(ActionController::RoutingError)
        end
      end
    end
  end

  describe "#incomplete" do
    let(:task) { FactoryGirl.create :task, completed_at: Time.now }
    let(:params) { { 'id' => task.id } }
    
    before { @user = task.user }
    
    it_should_behave_like "an authenticated controller action", :patch, :incomplete
    it_should_behave_like "an authenticated API controller action", :patch, :incomplete
    
    context "when signed in" do
      
      before { sign_in @user }
      
      context "with a valid task ID parameter" do
        it "sets completed_at on the Task instance" do
          patch :incomplete, params
          task.reload
          expect(task.completed?).to eq(false)
        end
      end

      context "with JSON request" do
        before { params['format'] = 'json' }

        it "returns 204 status" do
          patch :incomplete, params
          expect(response.status).to eq(204)
        end
      end
    
      context "with invalid parameters" do
        let(:params) { { 'id' => 'dsfsdsdf' } }
      
        it "throws an ActionController::RoutingError" do
          expect(->{ patch :incomplete, params }).to raise_error(ActionController::RoutingError)
        end
      end
    end
  end

  describe "#edit" do
    let(:task) { FactoryGirl.create :task }
    let(:params) { { 'id' => task.id } }
    
    before { @user = task.user }
    
    it_should_behave_like "an authenticated controller action", :get, :edit
    
    context "when signed in" do
      
      before { sign_in @user }
      
      context "with a valid task ID parameter" do
        it "returns success" do
          get :edit, params
          expect(response).to be_success
        end
      end
    
      context "with invalid parameters" do
        let(:params) { { 'id' => 'dsfsdsdf' } }
      
        it "throws an ActionController::RoutingError" do
          expect(->{ get :edit, params }).to raise_error(ActionController::RoutingError)
        end
      end
    end
  end
  
  describe "#update" do
    let(:task) { FactoryGirl.create :task }
    let(:params) do
      {
        'id' => task.id,
        'task' => { 'name' => 'test2' }
      }
    end
    
    before { @user = task.user }
    
    it_should_behave_like "an authenticated controller action", :patch, :update
    it_should_behave_like "an authenticated API controller action", :patch, :update
    
    context "when signed in" do
      
      before { sign_in @user }
      
      it "updates the Task instance" do
        patch :update, params
        task.reload
        expect(task.name).to eq('test2')
      end
      
      context "with valid parameters" do
        context "with HTML request" do
          it "redirects to tasks_path" do
            patch :update, params
            expect(response).to redirect_to(tasks_path)
          end
        end
        
        context "with JSON request" do
          before { params['format'] = 'json' }

          it "returns 204 status" do
            patch :update, params
            expect(response.status).to eq(204)
          end
        end
      end
      
      context "with invalid parameters" do
        let(:params) do
          {
            'id' => task.id,
            'task' => { 'name' => '' }
          }
        end
        
        it "renders the #edit view" do
          patch :update, params
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
