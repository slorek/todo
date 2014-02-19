require 'spec_helper'

describe TasksController do
  describe "#index" do
    it_should_behave_like "an authenticated controller action", :get, :index
  end
end
