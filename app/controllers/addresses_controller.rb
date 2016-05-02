class AddressesController < ApplicationController
	before_action :authenticate_user!

	def index
		@addresses = current_user.addresses
	end
	
	def new
		@address = Address.new
	end

	def create
		@address = current_user.addresses.build(address_params)
		if @address.save
			flash[:success] = 'Address added'
			redirect_to addresses_path
		else
			flash[:danger] = 'Not added'
			render 'new'
		end
	end

	def edit
		@address = current_user.addresses.find(params[:id])
	end

	def update
		@address = current_user.addresses.find(params[:id])
		if @address.update_attributes(address_params)
			flash[:success] = 'Updated Successfully'
			redirect_to addresses_path
		else
			flash[:danger] = 'Address not Updated'
			render 'edit'
		end
	end
	
	protected

		def address_params
			params.require(:address).permit(:address_type, :name, :address_1, :address_2, :city,
																			:state, :pincode, :landmark)
		end

end


