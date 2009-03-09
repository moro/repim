class SessionsController < ApplicationController
  include OpenIdAuthentication
  include Repim::RelyingParty
end
