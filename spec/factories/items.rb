FactoryBot.define do
  factory :item do
    name { "Banana Stand" }
    description { "There's always money in the banana stand." }
    unit_price { "1.50" }
    merchant_id { "#{Merchant.first.id}" }
    created_at { "whenever" }
    updated_at { "whenever" }
  end
end
