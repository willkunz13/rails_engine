require 'rails_helper'
  describe "Items_Merchant API" do
          it "sends a list of item's merchant" do
            create_list(:merchant, 1)
            create_list(:item, 3)


            get "/api/v1/items/#{Item.first.id}/merchant"

            expect(response).to be_successful

            item_merchant = JSON.parse(response.body)["data"]

            expect(item_merchant["type"]).to eq('merchant')
          end
  end
