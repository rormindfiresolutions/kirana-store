class Order < ActiveRecord::Base
	belongs_to :user
	belongs_to :address
	has_many :order_lines
	belongs_to :shop_profile
	validates :order_state, inclusion: { in: %w(new in-progress delivered closed) }
end
