module Repim
  module Signup
    def self.included(base)
      base.before_filter :authenticate, :except => [:create]
    end

    def create
      @user = User.new(params[:user])
      @user.identity_url = session[:identity_url]

      respond_to do |format|
        if @user.save
          flash[:notice] = 'User was successfully created.'
          reset_session
          self.current_user = @user
          format.html { redirect_to(after_create_url) }
        else
          format.html { render :action => "new" }
        end
      end
    end

    private
    def after_create_url
      root_url
    end
  end
end
