require 'spec_helper'

shared_examples_for "an authenticated controller action" do |method, action, params = {}|
  let(:user) { FactoryGirl.create(:user) }
  
  describe "session authentication" do
    context "when signed out" do
      before { sign_out user }
    
      it "redirects to the sign in page" do
        send(method, action, params)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  
    context "when signed in" do
      before { sign_in user }
      subject { send(method, action, params) }
    
      it "does not redirect to the sign in page" do
        expect(subject).not_to redirect_to(new_user_session_path)
      end
    end
  end
  
  describe "token authentication" do
    
    context "with no token parameters supplied" do
      
      before do
        params.reject! {|name, value| [:authentication_token, :authentication_email].include?(name.to_sym) }
        send(method, action, params)
      end
      
      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
    
    context "with the token parameter supplied" do
      
      before do
        params[:authentication_token] = user.authentication_token
        send(method, action, params)
      end
      
      it "returns a 401 HTTP status code" do
        expect(response.status).to eq(401)
      end
      
      context "and an email paramter supplied" do
        
        context "and the email and token parameters are valid" do
          before do
            params[:authentication_email] = user.email
            send(method, action, params)
          end
          
          it "returns a 200 HTTP status code" do
            expect(response.status).to eq(200)
          end
          
          it "does not set a cookie" do
            expect(response.cookies).to be_empty
          end
        end
        
        context "and the email parameter is invalid" do
          
          before do
            params[:authentication_email] = 'invalid@invalid.com'
            send(method, action, params)
          end
          
          it "returns a 401 HTTP status code" do
            expect(response.status).to eq(401)
          end
        end

        context "and the token parameter is invalid" do
          
          before do
            params[:authentication_token] = 'invalid'
            send(method, action, params)
          end
          
          it "returns a 401 HTTP status code" do
            expect(response.status).to eq(401)
          end
        end
      end
    end
  end
end
