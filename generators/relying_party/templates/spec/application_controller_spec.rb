require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ApplicationController do
  before :all do
    ApplicationController.user_klass = mock("User-Klass")
  end
  describe "#logged in" do
    before do
      session[:user_id] = 12345
      ApplicationController.user_klass.should_receive(:find_by_id).with(12345).and_return(@user = mock("user"))
    end

    it{ controller.should be_signed_in }
    it{ controller.current_user.should == @user }
  end
end

