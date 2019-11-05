class User::AddressesController < ApplicationController
  before_action :exclude_admin
  
  def index
    @addresses = current_user.addresses
  end

end
