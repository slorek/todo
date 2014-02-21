require 'spec_helper'

shared_examples_for "an authenticated API controller action" do |method, action|
  before { @user ||= FactoryGirl.create(:user) }
  
  describe "token authentication" do
    
    before { params[:format] = 'json' }
    
    context "with no token parameters supplied" do
      
      before do
        params.reject! {|name, value| [:authentication_token, :authentication_email].include?(name.to_sym) }
        send(method, action, params)
      end
      
      it "returns a 401 HTTP status code" do
        expect(response.status).to eq(401)
      end
    end
    
    context "with the token parameter supplied" do
      
      before do
        params[:authentication_token] = @user.authentication_token
        send(method, action, params)
      end
      
      it "returns a 401 HTTP status code" do
        expect(response.status).to eq(401)
      end
      
      context "and an email parameter supplied" do
        
        context "and the email and token parameters are valid" do
          before do
            params[:authentication_email] = @user.email
            send(method, action, params)
          end
          
          it "does not return an error status" do
            expect(response).not_to be_error
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
