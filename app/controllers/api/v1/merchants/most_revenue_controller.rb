class Api::V1::Merchants::MostRevenueController < ApplicationController

	def index
		number = params[:quantity]
		render json: MerchantSerializer.new(Merchant.most_revenue(number))
	end
end
