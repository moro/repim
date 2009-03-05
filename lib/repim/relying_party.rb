module Repim
  module RelyingParty
    def self.included(base)
      base.cattr_accessor :attribute_adapter
      base.cattr_accessor :user_klass
      base.cattr_accessor :signup_template
      base.user_klass = User if defined? User
      base.extend(ClassMethods)
    end

    module ClassMethods
      def use_attribute_exchange(prefixes, propaties)
        self.attribute_adapter = AxAttributeAdapter.new(prefixes, propaties)
      end
    end

    # render new.rhtml
    def new
    end

    def create
      options = { :method => "get" }
      options[attribute_adapter.necessity] = attribute_adapter.keys if attribute_adapter

      authenticate_with_open_id(params[:openid_url], options) do |result, identity_url, personal_data|
        if result.successful?
          authenticated(identity_url, personal_data)
        else
          unauthenticated(params.merge(:openid_url=>identity_url))
        end
      end
    rescue OpenID::Error => ex
      logger.debug{ [ex.message, ex.backtrace].flatten.join("\n") }
      unauthenticated(params)
    end

    def destroy
      logout_killing_session!
      flash[:notice] = "You have been logged out."

      redirect_back_or(after_logout_path)
    end

    private
    def authenticated(identity_url, personal_data = {})
      if user = user_klass.find_by_identity_url(identity_url)
        login_successfully(user, personal_data)
        redirect_back_or(after_login_path)
      else
        signup(identity_url, personal_data)
        render :template => (signup_template || "users/new")
      end
    end

    def login_successfully(user, personal_data)
      reset_session
      self.current_user = user
      flash[:notice] ||= "Logged in successfully"
    end

    # log login faulure. and re-render sessions/new
    def unauthenticated(assigns=params)
      flash[:error] = "Couldn't log you in as '#{assigns[:openid_url]}'"
      logger.warn "Failed login for '#{assigns[:openid_url]}' from #{request.remote_ip} at #{Time.now.utc}"

      @openid_url  = assigns[:openid_url]

      render :action => 'new'
    end

    def signup(identity_url, ax = {})
      session[:identity_url] = identity_url
      @user = user_klass.new( attribute_adapter ? attribute_adapter.adapt(ax) : {} )
    end

    def after_login_path; root_path ; end
    def after_logout_path; login_path ; end
  end
end
