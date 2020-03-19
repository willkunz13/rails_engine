require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    create_list(:merchant, 1)
    create_list(:item, 3)
    get '/api/v1/items'

    expect(response).to be_successful

	items = JSON.parse(response.body)["data"] 
	expect(items.count).to eq(3)
  end
  
  it "can get one item by its id" do
    create_list(:merchant, 1)
    id = create(:item).id

    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body)["data"]

    expect(response).to be_successful
    expect(item["id"].to_i).to eq(id)
  end
end
