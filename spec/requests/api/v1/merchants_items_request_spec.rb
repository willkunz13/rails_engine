require 'rails_helper'
  describe "Merchants_Items API" do
          it "sends a list of merchant's items" do
            create_list(:merchant, 1)
	    create_list(:item, 3)

		
            get "/api/v1/merchants/#{Merchant.first.id}/items"

            expect(response).to be_successful

            merchant_items = JSON.parse(response.body)["data"]

            expect(merchant_items.count).to eq(3)
          end
  end

