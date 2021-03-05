FactoryBot.define do
  factory :discount do
    name { "#{Faker::Nation.capital_city} Day Discount!"  }
    threshold { [5, 10, 20, 30].sample }
    percentage { [0.50, 0.10, 0.20, 0.30].sample }
    merchant
  end
end
