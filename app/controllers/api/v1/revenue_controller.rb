class Api::V1::RevenueController < ApplicationController
	require 'date'
	
	def show
		start = Time.zone.parse(params[:start]).utc
		stop = Time.zone.parse(params[:end]).utc
		hash = {}
		hash[:revenue] = InvoiceItem.joins(invoice: [:transactions]).where("transactions.result = 'success'").where("invoice_items.created_at BETWEEN '#{start}' AND '#{stop}'").pluck("SUM(invoice_items.unit_price * invoice_items.quantity)").first
		render json: hash
	end
end
