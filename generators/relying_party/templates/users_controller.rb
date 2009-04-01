class UsersController < ApplicationController
  include Repim::Signup

  def index
    @users = User.find(:all)

    respond_to do |format|
      format.html
      format.xml  { render :xml => @users }
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @user }
    end
  end

  # uncomment and edit this to change redirected url after signup.
  # private
  # def after_create_url
  #   user_url(current_user)
  # end
end
