require 'spec_helper'

describe User do
    
  let(:user) { FactoryGirl.build(:user) }
  
  describe "token generation" do
    
    describe "before_save callback" do
      it "calls #ensure_authentication_token" do
        expect(user).to receive(:ensure_authentication_token)
        user.save
      end
    end
    
    describe "#ensure_authentication_token" do
      context "when #authentication_token is blank" do
        it "calls #generate_authentication_token" do
          expect(user).to receive(:generate_authentication_token)
          user.ensure_authentication_token
        end
      end

      context "when #authentication_token is a string" do

        before { user.authentication_token = 'test' }

        it "does not call #generate_authentication_token" do
          expect(user).not_to receive(:generate_authentication_token)
          user.ensure_authentication_token
        end
      end
    end

    describe "#generate_authentication_token" do
      let(:generated_token) { user.send(:generate_authentication_token) }

      it "generates a token" do
        expect(generated_token).not_to eq(nil)
      end

      context "where a user exists with the same token" do
        before do
          FactoryGirl.create(:user, authentication_token: 'test')

          # Only stub the first call
          Devise.stub(:friendly_token) do
            Devise.unstub(:friendly_token)
            'test'
          end
        end

        it "does not duplicate the existing user's token" do
          expect(generated_token).not_to eq('test')
        end
      end
    end
  end
end
