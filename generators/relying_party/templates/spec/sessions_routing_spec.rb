require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SessionsController do
  describe "route generation" do
    it "should map #new -> /signin" do
      route_for(:controller => "sessions", :action => "new").should == "/signin"
    end

    it "should map #destroy -> /signout" do
      route_for(:controller => "sessions", :action => "destroy").should == {:path => "/signout", :method => "DELETE"}
    end

    it "should map #create" do
      route_for(:controller => "sessions", :action => "create").should == {:path => "/session", :method => "POST"}
    end
  end

  describe "route recognition" do
    it "should generate params for #new" do
      params_from(:get, "/signin").should == {:controller => "sessions", :action => "new"}
    end

    it "should generate params for #new" do
      params_from(:get, "/session/new").should == {:controller => "sessions", :action => "new"}
    end

    it "should generate params for #create" do
      params_from(:post, "/session").should == {:controller => "sessions", :action => "create"}
    end

    it "should generate params for #show (JS)" do
      params_from(:get, "/session.js").should == {:controller => "sessions", :action => "show", :format => "js"}
    end

    it "should generate params for #destroy" do
      params_from(:get, "/signout").should == {:controller => "sessions", :action => "destroy"}
    end

    it "should generate params for #destroy" do
      params_from(:delete, "/session").should == {:controller => "sessions", :action => "destroy"}
    end
  end
end
