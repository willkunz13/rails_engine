FactoryBot.define do
  factory :transaction do
    invoice_id { "MyString" }
    credit_card_number { "MyString" }
    credit_card_expiration_date { "MyString" }
    result { "MyString" }
    created_at { "MyString" }
    updated_at { "MyString" }
  end
end
