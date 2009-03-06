module Repim
  module Application
    def self.included(base)
      [:current_user].each do |method|
        base.helper_method method
        base.hide_action method
      end
    end

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
      session[:user_id] && User.find(params[:user_id]) rescue nil
    end

    def redirect_back_or(default)
      redirect_to(session[:return_to] || default)
    end
  end
end
