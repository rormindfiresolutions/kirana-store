class UserBasketDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :current_user
  def_delegator :@view, :record

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= %w(user_baskets.quantity)
  end

  def searchable_columns
    @searchable_columns ||= %w(user_baskets.quantity)
  end

  private

    def data
      records.map do |record|
        [
          ShopProduct.where('id = ?', record.shop_product_id).first.product_name,
          ShopProduct.where('id = ?', record.shop_product_id).first.selling_price,
          record.quantity,
          [
          record.quantity*ShopProduct.where('id = ?', record.shop_product_id).first.selling_price
          ],
          [
          link_to('Remove Item', record, method: :delete, data: { confirm: 'Are you sure?' })
          ]
        ]
      end
    end

    def get_raw_records
      UserBasket.all.where(user_id: current_user.id)
    end
end





