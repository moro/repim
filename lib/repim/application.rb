module Repim
  module Application
    def self.included(base)
      base.cattr_accessor :user_klass
      base.user_klass = (User rescue nil) # assign nil when LoadError and/or ConstMissing

      [:current_user, :signed_in?, :logged_in?].each do |method|
        base.helper_method method
        base.hide_action method
      end
    end

    def signed_in?; !!current_user ; end
    alias logged_in? signed_in?

    def current_user
      return nil if @__current_user__ == false
      return @__current_user__ if @__current_user__
      @__current_user__ ||= (user_from_session || false)
      current_user # call again
    end

    private
    def current_user=(user)
      @__current_user__ = user
      session[:user_id] = user.id
    end

    def user_from_session
      session[:user_id] && user_klass.find(session[:user_id]) rescue nil
    end

    def redirect_back_or(default)
      redirect_to(session[:return_to] || default)
    end
  end
end
