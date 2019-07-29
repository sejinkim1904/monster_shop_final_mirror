class User::AddressesController < User::BaseController
  before_action :get_address, only: [:edit, :update, :destroy]

  def index
    @user = current_user
  end

  def new
    @referer = []
    @referer << request.referer
  end

  def last_referer

  end

  def create
    @address = current_user.addresses.new(address_params)
    if @address.save
      flash[:notice] = "New address for #{@address.address_name} has been created."
      redirect_to profile_addresses_path
    else
      flash[:alert] = @address.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    if @address.shipped_orders.empty?
      render :edit
    else
      flash[:alert] = "Address for #{@address.address_name} is used in an order that is shipped. Cannot be updated"
      redirect_to profile_addresses_path
    end
  end

  def update
    if @address.update(address_params)
      flash[:notice] = "Address for #{@address.address_name} has been updated."
      redirect_to profile_addresses_path
    else
      flash[:alert] = @address.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    if @address.orders.empty?
      @address.destroy
      flash[:notice] = "Address for #{@address.address_name} has been removed."
    else
      flash[:alert] = "Address for #{@address.address_name} is used in an order that is shipped. Cannot be deleted"
    end
    redirect_to profile_addresses_path
  end

  private

  def address_params
    params.permit(:address_name, :address, :city, :state, :zip)
  end

  def get_address
    @address = Address.find(params[:id])
  end
end
