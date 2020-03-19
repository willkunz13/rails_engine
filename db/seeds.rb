# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'    

csv_text = File.read('data/customers.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Customer.create!(row.to_hash)
end

csv_text = File.read('data/merchants.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Merchant.create!(row.to_hash)
end

csv_text = File.read('data/invoices.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Invoice.create!(row.to_hash)
end

csv_text = File.read('data/items.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
	row["unit_price"] = row["unit_price"].to_f/100
  Item.create!(row.to_hash)
end

csv_text = File.read('data/transactions.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
  Transaction.create!(row.to_hash)
end

csv_text = File.read('data/invoice_items.csv')
csv = CSV.parse(csv_text, :headers => true)
csv.each do |row|
	row["unit_price"] = row["unit_price"].to_f/100
  InvoiceItem.create!(row.to_hash)
end

