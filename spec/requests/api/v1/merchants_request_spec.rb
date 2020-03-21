require 'rails_helper'
  describe "Merchants API" do
	  it "sends a list of merchants" do
	    create_list(:merchant, 3)

	    get "/api/v1/merchants"

	    expect(response).to be_successful

	    merchants = JSON.parse(response.body)["data"]

	    expect(merchants.count).to eq(3)
	  end
          it "can get one merchant by its id" do
	    id = create(:merchant).id
	    get "/api/v1/merchants/#{id}"
	    merchant = JSON.parse(response.body)["data"]
		
	    expect(response).to be_successful
	    expect(merchant["id"].to_i).to eq(id)
  	   end
	it "can create a new merchant" do
	    merchant_params = { name: "Mike's Supply Chain" }

	    post "/api/v1/merchants", params: {merchant: merchant_params}
	    merchant = Merchant.last

	    expect(response).to be_successful
	    expect(merchant.name).to eq(merchant_params[:name])
	end

	it "can update an existing merchant" do
	  id = create(:merchant).id
	  previous_name = Merchant.last.name
	  merchant_params = { name: "Sledge" }

	  put "/api/v1/merchants/#{id}", params: {merchant: merchant_params}
	  merchant = Merchant.find_by(id: id)

	  expect(response).to be_successful
	  expect(merchant.name).to_not eq(previous_name)
	  expect(merchant.name).to eq("Sledge")
	end

	it "can destroy an merchant" do
	    merchant = create(:merchant)
	 
	    expect(Merchant.count).to eq(1)
	 
	    delete "/api/v1/merchants/#{merchant.id}"
	 
	    expect(response).to be_successful
	    expect(Merchant.count).to eq(0)
	    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
	end

	it "finds specific merchant" do
		Merchant.create(name: "lePenio", created_at: "2012-03-27 14:53:59")
		Merchant.create(name: "lapenio", created_at: "2012-03-27 14:53:59")
	    get '/api/v1/merchants/find?name=pen&created_at=2012-03-27 14:53:59'

	    expect(response).to be_successful
	    merchant = JSON.parse(response.body)["data"]
	    expect(merchant["id"].to_i).to eq(Merchant.first.id)
	end

	it "finds specific merchants" do
		Merchant.create(name: "lePenio", created_at: "2012-03-27 14:53:59")
		Merchant.create(name: "lapenio", created_at: "2012-03-27 14:53:59")
	    get '/api/v1/merchants/find_all?name=pen&created_at=2012-03-27 14:53:59'

	    expect(response).to be_successful
	    merchants = JSON.parse(response.body)["data"]
	    expect(merchants.first["id"].to_i).to eq(Merchant.first.id)
	    expect(merchants.last["id"].to_i).to eq(Merchant.last.id)
	end
   end
