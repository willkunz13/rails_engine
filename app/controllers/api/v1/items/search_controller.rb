class Api::V1::Items::SearchController < ApplicationController

	def index
                render json: ItemSerializer.new(Item.filter(request.query_parameters))
        end

	def show
		render json: ItemSerializer.new(Item.filter(request.query_parameters).first)
	end
end
