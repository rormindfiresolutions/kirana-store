class ShopProfile < ActiveRecord::Base
	has_one :address
	has_and_belongs_to_many :users
	has_one :shop_inventory_detail
	has_many :shop_products
	has_one :order_line
	has_many :orders
	has_many :shipping_charges

	VALID_SHOP_NAME_REGEX = /\A[a-zA-Z0-9_ .]+\z/
	validates :shop_name, length: { minimum: 3, maximum: 30 }, format: { with: VALID_SHOP_NAME_REGEX }
	validates :phone_number, length: { is: 10 }, numericality: { only_integer: true }
	# VALID_EMAIL_REGEX = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/
	# validates :email, allow_blank: true, format: { with: VALID_EMAIL_REGEX }
	validates_format_of :email, with: Devise::email_regexp

end