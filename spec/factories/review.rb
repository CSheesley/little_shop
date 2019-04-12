FactoryBot.define do
  factory :review do
    user
    order_item
    sequence(:title) { |n| "Review Title #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:rating) { ([1,2,3,4,5].sample) }
  end
end
