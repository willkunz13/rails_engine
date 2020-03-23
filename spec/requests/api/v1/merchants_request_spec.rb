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

	it "merchant most revenue" do
		customer = create(:customer)
		merchant1 = Merchant.create(name: "Schroder", created_at: "2012-03-27 14:53:59", updated_at: "2012-03-27 16:12:25 UTC")
                merchant2 = Merchant.create(name: "Tillman", created_at: "2012-03-27 14:53:59 UTC",  updated_at: "2012-03-27 14:53:59 UTC")
		item1 = Item.create(name: "A", description: "A", unit_price: "751.07", merchant_id: merchant1.id, created_at: "2011-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
		item2 = Item.create(name: "B", description: "B", unit_price: "91.00", merchant_id: merchant1.id, created_at: "2010-04-27 14:57:59 UTC", updated_at: "2011-03-17 15:53:59 UTC")
		item3 = Item.create(name: "C", description: "C", unit_price: "134.90", merchant_id: merchant2.id, created_at: "2010-01-23 04:58:59 UTC", updated_at: "2010-02-27 15:54:69 UTC")
		item4 = Item.create(name: "D", description: "D", unit_price: "135.93", merchant_id: merchant2.id, created_at: "2011-06-23 02:53:69 UTC", updated_at: "2012-12-22 15:54:73 UTC")
		invoice1 = Invoice.create(customer_id: customer.id, merchant_id: merchant1.id, status: "shipped", created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
		invoice1.items << item1
		invoice1.items << item2
		invoice2 = Invoice.create(customer_id: customer.id, merchant_id: merchant2.id, status: "shipped", created_at: "2013-23-25 19:54:09 UTC", updated_at: "2014-05-25 09:55:79 UTC")
		invoice2.items << item3
		invoice2.items << item4
		transaction1 = Transaction.create(invoice_id: invoice1.id, credit_card_number: "4654405418249632", result: "failure")
		transaction2 = Transaction.create(invoice_id: invoice1.id, credit_card_number: "4654405123249632", result: "success")
		transaction3 = Transaction.create(invoice_id: invoice2.id, credit_card_number: "1234405418249632", result: "success")
		get '/api/v1/merchants/most_revenue?quantity=1'
		expect(response).to be_successful
		merchants = JSON.parse(response.body)["data"]
                expect(merchants.first["attributes"]["name"]).to eq("Schroder")
	end

	it "merchant most items" do
                customer = create(:customer)
                merchant1 = Merchant.create(name: "Schroder", created_at: "2012-03-27 14:53:59", updated_at: "2012-03-27 16:12:25 UTC")
                merchant2 = Merchant.create(name: "Tillman", created_at: "2012-03-27 14:53:59 UTC",  updated_at: "2012-03-27 14:53:59 UTC")
                item1 = Item.create(name: "A", description: "A", unit_price: "751.07", merchant_id: merchant1.id, created_at: "2011-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
                item2 = Item.create(name: "B", description: "B", unit_price: "91.00", merchant_id: merchant1.id, created_at: "2010-04-27 14:57:59 UTC", updated_at: "2011-03-17 15:53:59 UTC")
                item5 = Item.create(name: "Q", description: "Q", unit_price: "91.00", merchant_id: merchant1.id, created_at: "2010-04-27 14:57:59 UTC", updated_at: "2011-03-17 15:53:59 UTC")
                item3 = Item.create(name: "C", description: "C", unit_price: "134.90", merchant_id: merchant2.id, created_at: "2010-01-23 04:58:59 UTC", updated_at: "2010-02-27 15:54:69 UTC")
                item4 = Item.create(name: "D", description: "D", unit_price: "135.93", merchant_id: merchant2.id, created_at: "2011-06-23 02:53:69 UTC", updated_at: "2012-12-22 15:54:73 UTC")
                invoice1 = Invoice.create(customer_id: customer.id, merchant_id: merchant1.id, status: "shipped", created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
                invoice1.items << item1
                invoice1.items << item2
		invoice1.items << item5
                invoice2 = Invoice.create(customer_id: customer.id, merchant_id: merchant2.id, status: "shipped", created_at: "2013-23-25 19:54:09 UTC", updated_at: "2014-05-25 09:55:79 UTC")
                invoice2.items << item3
                invoice2.items << item4
                transaction1 = Transaction.create(invoice_id: invoice1.id, credit_card_number: "4654405418249632", result: "failure")
                transaction2 = Transaction.create(invoice_id: invoice1.id, credit_card_number: "4654405123249632", result: "success")
                transaction3 = Transaction.create(invoice_id: invoice2.id, credit_card_number: "1234405418249632", result: "success")
                get '/api/v1/merchants/most_items?quantity=1'
		expect(response).to be_successful
		merchants = JSON.parse(response.body)["data"]
                expect(merchants.first["attributes"]["name"]).to eq("Schroder")
	end

	it "revenue across date range" do
                customer = create(:customer)
                merchant1 = Merchant.create(name: "Schroder", created_at: "2012-03-27 14:53:59", updated_at: "2012-03-27 16:12:25 UTC")
                merchant2 = Merchant.create(name: "Tillman", created_at: "2012-03-27 14:53:59 UTC",  updated_at: "2012-03-27 14:53:59 UTC")
                item1 = Item.create(name: "A", description: "A", unit_price: "751.07", merchant_id: merchant1.id, created_at: "2011-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
                item2 = Item.create(name: "B", description: "B", unit_price: "91.00", merchant_id: merchant1.id, created_at: "2010-04-27 14:57:59 UTC", updated_at: "2011-03-17 15:53:59 UTC")
                item5 = Item.create(name: "Q", description: "Q", unit_price: "91.00", merchant_id: merchant1.id, created_at: "2010-04-27 14:57:59 UTC", updated_at: "2011-03-17 15:53:59 UTC")
                item3 = Item.create(name: "C", description: "C", unit_price: "134.90", merchant_id: merchant2.id, created_at: "2010-01-23 04:58:59 UTC", updated_at: "2010-02-27 15:54:69 UTC")
                item4 = Item.create(name: "D", description: "D", unit_price: "135.93", merchant_id: merchant2.id, created_at: "2011-06-23 02:53:69 UTC", updated_at: "2012-12-22 15:54:73 UTC")
                invoice1 = Invoice.create(customer_id: customer.id, merchant_id: merchant1.id, status: "shipped", created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
                invoice2 = Invoice.create(customer_id: customer.id, merchant_id: merchant2.id, status: "shipped", created_at: "2013-23-25 19:54:09 UTC", updated_at: "2014-05-25 09:55:79 UTC")
		invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 2, unit_price: item1.unit_price, created_at: '2012-03-27 14:54:09 UTC')
		invoice_item2 = InvoiceItem.create(item_id: item2.id, invoice_id: invoice1.id, quantity: 1, unit_price: item2.unit_price, created_at: '2012-03-27 14:54:09 UTC')
		invoice_item3 = InvoiceItem.create(item_id: item3.id, invoice_id: invoice2.id, quantity: 3, unit_price: item5.unit_price, created_at: '2012-03-27 14:54:09 UTC')
                transaction1 = Transaction.create(invoice_id: invoice1.id, credit_card_number: "4654405418249632", result: "failure")
                transaction2 = Transaction.create(invoice_id: invoice1.id, credit_card_number: "4654405123249632", result: "success")
                transaction3 = Transaction.create(invoice_id: invoice2.id, credit_card_number: "1234405418249632", result: "success")
                get '/api/v1/revenue?start=2012-02-09&end=2012-04-24'
                expect(response).to be_successful
                revenues = JSON.parse(response.body)
		expect(revenues["revenue"]).to eq(1866.14)
        end

	it "merchant most items" do
                customer = create(:customer)
                merchant1 = Merchant.create(name: "Schroder", created_at: "2012-03-27 14:53:59", updated_at: "2012-03-27 16:12:25 UTC")
                merchant2 = Merchant.create(name: "Tillman", created_at: "2012-03-27 14:53:59 UTC",  updated_at: "2012-03-27 14:53:59 UTC")
                item1 = Item.create(name: "A", description: "A", unit_price: "751.07", merchant_id: merchant1.id, created_at: "2011-03-27 14:53:59 UTC", updated_at: "2012-03-27 14:53:59 UTC")
                item2 = Item.create(name: "B", description: "B", unit_price: "91.00", merchant_id: merchant1.id, created_at: "2010-04-27 14:57:59 UTC", updated_at: "2011-03-17 15:53:59 UTC")
                item5 = Item.create(name: "Q", description: "Q", unit_price: "91.00", merchant_id: merchant1.id, created_at: "2010-04-27 14:57:59 UTC", updated_at: "2011-03-17 15:53:59 UTC")
                item3 = Item.create(name: "C", description: "C", unit_price: "134.90", merchant_id: merchant2.id, created_at: "2010-01-23 04:58:59 UTC", updated_at: "2010-02-27 15:54:69 UTC")
                item4 = Item.create(name: "D", description: "D", unit_price: "135.93", merchant_id: merchant2.id, created_at: "2011-06-23 02:53:69 UTC", updated_at: "2012-12-22 15:54:73 UTC")
                invoice1 = Invoice.create(customer_id: customer.id, merchant_id: merchant1.id, status: "shipped", created_at: "2012-03-25 09:54:09 UTC", updated_at: "2012-03-25 09:54:09 UTC")
                invoice2 = Invoice.create(customer_id: customer.id, merchant_id: merchant2.id, status: "shipped", created_at: "2013-23-25 19:54:09 UTC", updated_at: "2014-05-25 09:55:79 UTC")
		 invoice_item1 = InvoiceItem.create(item_id: item1.id, invoice_id: invoice1.id, quantity: 2, unit_price: item1.unit_price, created_at: '2012-03-27 14:54:09 UTC')
                invoice_item2 = InvoiceItem.create(item_id: item2.id, invoice_id: invoice1.id, quantity: 1, unit_price: item2.unit_price, created_at: '2012-03-27 14:54:09 UTC')
                invoice_item3 = InvoiceItem.create(item_id: item3.id, invoice_id: invoice2.id, quantity: 3, unit_price: item5.unit_price, created_at: '2012-03-27 14:54:09 UTC')
                transaction1 = Transaction.create(invoice_id: invoice1.id, credit_card_number: "4654405418249632", result: "failure")
                transaction2 = Transaction.create(invoice_id: invoice1.id, credit_card_number: "4654405123249632", result: "success")
                transaction3 = Transaction.create(invoice_id: invoice2.id, credit_card_number: "1234405418249632", result: "success")
                get "/api/v1/merchants/#{merchant1.id}/revenue"
		expect(response).to be_successful
                revenue = JSON.parse(response.body)
                expect(revenue["revenue"]).to eq(1593.14)
	end
   end
