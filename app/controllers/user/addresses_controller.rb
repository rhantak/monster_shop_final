class User::AddressesController < ApplicationController
  before_action :exclude_admin

  def index
    @addresses = current_user.addresses
  end

  def show
    @address = Address.find(params[:address_id])
  end

  def new

  end

  def create
    address = current_user.addresses.new(address_params)
    if address.save
      flash[:success] = "New address has been created!"
      redirect_to '/profile/addresses'
    else
      flash.now[:error] = address.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @address = Address.find(params[:address_id])
  end

  def update
    @address = Address.find(params[:address_id])
    if @address.update(address_params)
      flash[:success] = "Your address has been updated!"
      redirect_to "/profile/addresses/#{@address.id}"
    else
      flash.now[:error] = @address.errors.full_messages.to_sentence
      render :edit
    end
  end

  private
    def address_params
      params.permit(:nickname, :name, :street_address, :city, :state, :zip)
    end
end
