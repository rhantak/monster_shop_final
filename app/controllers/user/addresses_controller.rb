class User::AddressesController < ApplicationController
  before_action :exclude_admin

  def index
    @addresses = Address.where(user_id: current_user.id)
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

  def destroy
    address = Address.find(params[:address_id])
    if address.orders.empty?
      address.delete
      flash[:notice] = "Your address has been deleted."
      redirect_to '/profile/addresses'
    else
      flash[:notice] = "You have order(s) going to this address! Please change their destination(s) before deleting this address."
      redirect_to "/profile/addresses/#{address.id}"
    end
  end

  private
    def address_params
      params.permit(:nickname, :name, :street_address, :city, :state, :zip)
    end
end
