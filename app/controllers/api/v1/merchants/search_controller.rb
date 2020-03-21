class Api::V1::Merchants::SearchController < ApplicationController

	def index  
                render json: MerchantSerializer.new(Merchant.filter(request.query_parameters))
        end
	
        def show        
                render json: MerchantSerializer.new(Merchant.filter(request.query_parameters).first)
        end         
end   
