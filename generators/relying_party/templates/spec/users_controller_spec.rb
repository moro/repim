require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  describe "responding to GET index" do
    before do
      controller.stub!(:authenticate).and_return true
    end
    it "should expose all users as @users" do
      User.should_receive(:find).with(:all).and_return([mock_user])
      get :index
      assigns[:users].should == [mock_user]
    end

    describe "with mime type of xml" do
      it "should render all users as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        User.should_receive(:find).with(:all).and_return(users = mock("Array of Users"))
        users.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to GET show" do
    before do
      controller.stub!(:authenticate).and_return true
    end

    it "should expose the requested user as @user" do
      User.should_receive(:find).with("37").and_return(mock_user)
      get :show, :id => "37"
      assigns[:user].should equal(mock_user)
    end

    describe "with mime type of xml" do
      it "should render the requested user as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        User.should_receive(:find).with("37").and_return(mock_user)
        mock_user.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      before do
        User.should_receive(:new).with({'these' => 'params'}).and_return(mock_user(:save => true))

        @identity_url = session[:identity_url] = "http://moro.openid.example.com/"
        mock_user.should_receive(:identity_url=).with(@identity_url)

        post :create, :user => {:these => 'params'}
      end

      it "should expose a newly created user as @user" do
        assigns(:user).should equal(mock_user)
      end

      it "session[:identity_url] should be removed" do
        session[:identity_url].should be_blank
      end

      it "should redirect to the created user" do
        response.should redirect_to(user_url(mock_user))
      end
    end

    describe "with invalid params" do
      before do
        User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:save => false))

        @identity_url = session[:identity_url] = "http://moro.openid.example.com/"
        mock_user.should_receive(:identity_url=).with(@identity_url)

        post :create, :user => {:these => 'params'}
      end

      it "should expose a newly created but unsaved user as @user" do
        assigns(:user).should equal(mock_user)
      end

      it "should re-render the 'new' template" do
        response.should render_template('new')
      end

      it "session[:identity_url] should == original" do
        session[:identity_url].should == @identity_url
      end
    end
  end
end
