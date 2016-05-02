class UsersController < ApplicationController
  before_action :authenticate_user! , only: [:index, :show, :profile]
  skip_before_action :verify_authenticity_token, only: :search_shop

	def home
		render layout: false
	end

	def about
	end

	def contact
	end
	
	def index
		authorize User
		respond_to do |format|
      format.html
      format.json {render json: UserDatatable.new(view_context)}
    end
	end
	
	def show
		@user = User.find_by(id: params[:id])
	end

	def profile
	end

	def search_shop
		@search_address = Address.where(pincode_params)
		@shop_address = @search_address.where.not(shop_profile_id: nil)
		@shops_id = @shop_address.select('shop_profile_id')
		if @shops_id.blank?
			flash[:danger] = 'Sorry! No Shops Available'
			redirect_to root_path
		else
	 		@shops = Array.new
	 		@shops_id.each do |id|
	 			@shops.push ShopProfile.find_by(id: id.shop_profile_id)
	 		end
	 	end
 	end

	private
		def pincode_params
			params.require(:address).permit(:pincode)
		end

end