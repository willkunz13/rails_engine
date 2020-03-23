class Api::V1::Merchants::RevenueController < ApplicationController

	def show
		hash = {}
		id_merchant = params[:id]
                hash[:revenue] = Merchant.joins(items: [invoices: [:transactions]]).group("merchants.id").where("transactions.result = 'success'").where("merchants.id = #{id_merchant}").pluck("SUM(invoice_items.unit_price * invoice_items.quantity)").first
		render json: hash
	end

end
