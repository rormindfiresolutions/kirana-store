 class ShopProductsController < ApplicationController
	before_action :authenticate_user!, except: :show_image
	before_action :check_status, only: [:new, :create]

	def new
		@shop_product = ShopProduct.new
		# @products = Product.where("is_approved = true")
		@shop_profile = ShopProfile.find(params[:shop_profile_id])
		@categories = Category.all
		@brands = Brand.all
	end

	def create
		@shop = ShopProfile.find(params[:shop_profile_id])
		if current_user.shopkeeper?
			product = Product.find(params[:product_id])
			shop_product = ShopProduct.new

			if @shop.shop_products.find_by_product_id(product.id)
				flash[:danger] = 'Product Already Exists'
			else
				shop_product.product_name = product.product_name
				shop_product.image = product.image
				shop_product.unit_type = product.unit_type
				shop_product.product_description = product.product_description
				shop_product.category_id = product.category_id
				shop_product.product_id = product.id
				shop_product.brand_name = product.brand.brand_name
				shop_product.create_shop_inventory
				@shop.shop_products << shop_product
				@shop.save
				flash[:success] = 'You added a Product to your Shop'
			end
			redirect_to request.referer || root_path
			
		else
			flash[:danger] = 'You cannot add Products'
			redirect_to root_path
		end
	end

	def edit
		@shop = ShopProfile.find(params[:shop_profile_id])
		@shop_product = ShopProduct.find(params[:id])
	end

	def update
		@shop = ShopProfile.find(params[:shop_profile_id])
		@shop_product = ShopProduct.find(params[:id])
		if @shop_product.update_attributes(shop_product_params)
			flash[:success] = 'You updated a Product in your Shop'
			redirect_to shop_profile_path(@shop_product.shop_profile_id)
		else
			render 'edit'
		end
	end

	def index
		authorize ShopProduct
		@shop_profile = ShopProfile.find(params[:shop_profile_id])
		respond_to do |format|
      format.html
      format.json {render json: ShopProductDatatable.new(view_context, {shop_profile: @shop_profile})}
    end
  end

  def show_image
		@shop_product = ShopProduct.find(params[:id])
		if @shop_product.image.nil?
			send_data open("#{Rails.root}/lib/seeds/images/no_image.jpg", "rb").read, type: 'image/jpg'
		else
			send_data @shop_product.image, type: 'image/jpg'
		end
	end

	def add_product_manually
		@shop = ShopProfile.find_by(id: params[:shop_profile_id])
		@shop_product = ShopProduct.new(shop_product_params)
		@shop_product.brand_name = Brand.find_by(id: params[:product][:brand_id]).brand_name if !@shop_product.brand_name
		@shop_product.build_shop_inventory(shop_inventory_params)
		if @shop.shop_products << @shop_product and @shop.save
			flash[:success] = 'You added a Product to your Shop'
			redirect_to shop_profile_path(@shop_product.shop_profile_id)
		else
			render 'new'
		end
	end

	private

	def shop_product_params
		params.require(:shop_product).permit(:product_name, :product_description, :unit_type, :category_name,
		 																:brand_name, :selling_price, :mrp, :category_id, :brand_id, 
		 																:product_id, :image)
	end

	def shop_inventory_params
		params.require(:shop_inventory).permit(:quantity)
	end

  def check_status
		@shop = ShopProfile.find_by(id: params[:shop_profile_id])
		if @shop.is_approved == false
			flash[:danger] = 'You are not approved to add products'
			redirect_to root_path
		end
	end

end






