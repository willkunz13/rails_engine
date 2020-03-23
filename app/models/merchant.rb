class Merchant < ApplicationRecord
	has_many :items
	include Filterable

	def self.most_revenue(number)
		Merchant.joins(items: [invoices: [:transactions]]).group("merchants.id").where("transactions.result = 'success'").order("SUM(invoice_items.quantity * invoice_items.unit_price) DESC").limit(number.to_i)
	end

	def self.most_items(number)
		Merchant.joins(items: [:invoice_items]).group("merchants.id").order("COUNT(invoice_items.id) DESC").limit(number.to_i)
	end
	
        scope :filter_by_name, -> (name) { where(Merchant.arel_table[:name].lower.matches("%#{name.downcase}%"))}
        scope :filter_by_created_at, -> (created_at) { where created_at: created_at}
        scope :filter_by_updated_at, -> (updated_at) { where updated_at: updated_at}
end
