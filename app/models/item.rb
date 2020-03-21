class Item < ApplicationRecord
	belongs_to :merchant
	has_many :invoice_items
        has_many :invoices, through: :invoice_items
	include Filterable

	scope :filter_by_name, -> (name) { where(Item.arel_table[:name].lower.matches("%#{name.downcase}%"))}
	scope :filter_by_description, -> (description) { where(Item.arel_table[:description].lower.matches("%#{description.downcase}%"))}
	scope :filter_by_unit_price, -> (unit_price) {  where unit_price: unit_price}
	scope :filter_by_merchant_id, -> (merchant_id) { where merchant_id: merchant_id}
	scope :filter_by_created_at, -> (created_at) { where created_at: created_at}
	scope :filter_by_updated_at, -> (updated_at) { where updated_at: updated_at}
end
