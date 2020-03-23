Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	namespace :api do
    		namespace :v1 do
			get '/revenue', to: 'revenue#show'
			namespace :items do
				get '/find', to: 'search#show'
				get '/find_all', to: 'search#index'
			end
			namespace :merchants do
				get '/find', to: 'search#show'
				get '/find_all', to: 'search#index'
				get '/most_revenue', to: 'most_revenue#index'
				get '/most_items', to: 'most_items#index'
				get '/:id/revenue', to: 'revenue#show'
			end
     			resources :items, only: [:index, :show, :create, :update, :destroy]
			get '/items/:item_id/merchant', to: 'items_merchant#index'
			resources :merchants, only: [:index, :show, :create, :update, :destroy]
			get '/merchants/:merchant_id/items', to: 'merchants_items#index'
    		end
  	end
end
