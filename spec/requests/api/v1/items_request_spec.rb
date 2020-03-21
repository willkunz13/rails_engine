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

  it "can create a new item" do
    create_list(:merchant, 1)
    item_params = { name: "Saw", description: "I want to play a game", unit_price: 100.00, merchant_id: "#{Merchant.first.id}" }

    post "/api/v1/items", params: {item: item_params}
    item = Item.last

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
  end

  it "can update an existing item" do
    create_list(:merchant, 1)
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Sledge" }
  
    put "/api/v1/items/#{id}", params: {item: item_params}
    item = Item.find_by(id: id)
  
    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Sledge")
  end

  it "can destroy an item" do
    create_list(:merchant, 1)
    item = create(:item)
  
    expect(Item.count).to eq(1)
  
    delete "/api/v1/items/#{item.id}"
  
    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "finds specific item" do
    create_list(:merchant, 1)
    Item.create(name: "lePenio", description: "fairly blueish and what not", unit_price: "130.00", merchant_id: "#{Merchant.first.id}")
    create_list(:item, 3)
    get '/api/v1/items/find?name=pen&description=blue'

    expect(response).to be_successful
    item = JSON.parse(response.body)["data"]
    expect(item["id"].to_i).to eq(Item.first.id)
  end

  it "finds specific item" do
    create_list(:merchant, 1)
    Item.create(name: "lePenio", description: "fairly blueish and what not", unit_price: "130.00", merchant_id: "#{Merchant.first.id}")
    create_list(:item, 3)
    Item.create(name: "laPenio", description: "fairly blueish and what not", unit_price: "130.00", merchant_id: "#{Merchant.first.id}")
    get '/api/v1/items/find_all?name=pen&description=blue'

    expect(response).to be_successful
    items = JSON.parse(response.body)["data"]
    expect(items.first["id"].to_i).to eq(Item.first.id)
    expect(items.last["id"].to_i).to eq(Item.last.id)
  end
end
