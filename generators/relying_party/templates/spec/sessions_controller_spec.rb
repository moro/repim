require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  before :all do
    SessionsController.user_klass = mock("User-Klass")
  end

  #Delete this example and add some real ones
  it "should use SessionsController" do
    controller.should be_an_instance_of(SessionsController)
  end

  it "get new should be success" do
    get :new
    response.should be_success
  end

  def mock_out_authenticattion(controller, url, is_success)
    result = mock("result")
    result.should_receive(:successful?).and_return is_success

    controller.
      should_receive(:authenticate_with_open_id).
      with(url, an_instance_of(Hash)).
      and_return{|url, ax, block| block.call(result, url, ax) }
  end

  describe "authentication success" do
    before do
      url = "---openid-url---"

      @user = mock("user", :id => 12345)
      SessionsController.user_klass.should_receive(:find_by_identity_url).with(url).and_return(@user)

      controller.should_receive(:root_path).and_return("/")
      mock_out_authenticattion(controller, url, true)

      post :create, :openid_url =>url
    end

    it{ response.should redirect_to("/") }
    it{ session[:user_id].should == 12345 }
    it{ controller.current_user.should == @user }
    it{ controller.should be_signed_in }
  end

  describe "authentication success but user not found then render users/new" do
    before do
      url = "---openid-url---"
      SessionsController.user_klass.should_receive(:find_by_identity_url).with(url).and_return(nil)
      SessionsController.user_klass.should_receive(:new).with({}).and_return(@user = mock("user"))

      mock_out_authenticattion(controller, url, true)

      post :create, :openid_url =>url
    end

    it{ response.should render_template("users/new") }
    it{ controller.current_user.should be_nil }
    it{ controller.should_not be_signed_in }
    it{ assigns[:user].should == @user }
  end

  describe "authentication failed" do
    before do
      url = "---openid-url---"

      mock_out_authenticattion(controller, url, false)

      post :create, :openid_url =>url
    end

    it{ response.should render_template("sessions/new") }
    it{ assigns[:user].should be_nil }
    it{ controller.current_user.should be_nil }
    it{ session[:user_id].should be_nil }
    it{ flash[:error].should_not be_blank }
  end
end
