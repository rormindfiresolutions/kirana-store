class ProductsController < ApplicationController
	before_action :authenticate_user!, except: :show_image

	def new
		authorize Product
		@product = Product.new
		@categories = Category.all
		@category = Category.new
		@brands = Brand.all
		@brand = Brand.new
	end

	def create
	 	authorize Product
		@product = Product.new(product_params)
		@brand = Brand.new(brand_params)
		@category = Category.new(category_params)
		@product.category_id = @category.id
		@product.build_category(category_params)
		@product.brand_id = @brand.id
		@product.build_brand(brand_params)
		@product.is_approved = false
		@product.is_active = false
		if @product.save 
			flash[:success] = 'Successfully Added a new Product'
			redirect_to root_path
		else
			render 'new'
		end
	end

	def index
		@products = Product.all
		@shop_profile = ShopProfile.find_by(id: params[:shop_profile_id])
		@items = @products.paginate(page: params[:page], per_page: 6).search(params[:search])
		if !params[:category_id].nil?
			@items = @products.where(category_id: params[:category_id]).paginate(page: params[:page], per_page: 6)
		end	
		authorize @shop_profile
	end


	def product_index
		authorize Product
		respond_to do |format|
      format.html
      format.json {render json: ProductDatatable.new(view_context)}
    end
	end

	def change_status
		authorize Product
 		@item = Product.find_by(id: params[:product_id])
 		unless @item.nil?
	 	  unless @item.is_approved
	 	  	@item.is_approved = true
	 	  	@item.save 
	 	  	flash[:success] = 'Approved'
	 	  	redirect_to request.referrer || root_path
	 	  else
	 	  	@item.is_approved = false
	 	  	@item.save 
	 	  	flash[:danger] = 'Not Approved'
	 	  	redirect_to request.referrer || root_path
	 	  end
	 	else
	 		flash[:danger] = 'Item not exist'
	 	  redirect_to request.referrer || root_path 
	 	end	  
 	end

 	def change_activation_status
 		authorize Product
 		@item = Product.find(params[:product_id])
 	  if ! @item.is_active
 	  	@item.is_active = true
 	  	@item.save 
 	  	flash[:success] = 'Activated'
 	  	redirect_to request.referrer || root_path
 	  else
 	  	@item.is_active = false
 	  	@item.save 
 	  	flash[:warning] = 'Not Activated'
 	  	redirect_to request.referrer || root_path
 	  end
 	end

 	def show_image
		@product = Product.find(params[:id])
		if @product.image.nil?
			send_data open("#{Rails.root}/lib/seeds/images/no_image.jpg", "rb").read, type: 'image/jpg'
		else
			send_data @product.image, type: 'image/jpg'
		end
	end


	private

		def product_params
			params.require(:product).permit(:product_name, :product_description, :unit_type, :category_name,
			 																:brand_name, :is_approved, :is_active, :category_id, :image)
		end

		def brand_params
			params.require(:brand).permit(:brand_name)
		end

		def category_params
			params.require(:category).permit(:category_name)
		end
end


