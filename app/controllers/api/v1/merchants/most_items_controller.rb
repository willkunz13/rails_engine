class Api::V1::Merchants::MostItemsController < ApplicationController

        def index
                number = params[:quantity]
                render json: MerchantSerializer.new(Merchant.most_items(number))
        end
end
