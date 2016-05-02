class ShopProductDatatable < AjaxDatatablesRails::Base
  def_delegator :@view, :link_to
  def_delegator :@view, :edit_shop_profile_shop_product_path
  def_delegator :@view, :record
  def_delegator :@view, :shop_inventory_details_path

  include AjaxDatatablesRails::Extensions::WillPaginate

  def sortable_columns
    @sortable_columns ||= %w(shop_products.product_name)
  end

  def searchable_columns
    @searchable_columns ||= %w(shop_products.product_name)
  end

  private

    def data
      records.map do |record|
        [
          link_to(record.product_name, edit_shop_profile_shop_product_path(options[:shop_profile], record)),
          record.unit_type,
          record.shop_inventory.quantity,
          link_to("Transactions", shop_inventory_details_path(shop_product_id: record.id))
        ]
      end
    end

    def get_raw_records
      ShopProduct.where(shop_profile_id: options[:shop_profile])
    end
end
