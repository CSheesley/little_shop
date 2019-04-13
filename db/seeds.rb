require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

corey = create(:user, name: "Corey", email: "corey@email.com", password: "password")
item_1 = create(:item)
item_2 = create(:item)
item_3 = create(:item)
item_4 = create(:item)

order_1 = create(:shipped_order, user_id: corey.id)
order_2 = create(:shipped_order, user_id: corey.id)
order_3 = create(:order, user_id: corey.id)

order_item_101 = create(:order_item, order_id: order_1.id, item_id: item_1.id, fulfilled: true)
order_item_102 = create(:order_item, order_id: order_1.id, item_id: item_2.id, fulfilled: true)

order_item_201 = create(:order_item, order_id: order_2.id, item_id: item_2.id, fulfilled: true)
order_item_202 = create(:order_item, order_id: order_2.id, item_id: item_3.id, fulfilled: true)

order_item_301 = create(:order_item, order_id: order_3.id, item_id: item_3.id, fulfilled: true)
order_item_302 = create(:order_item, order_id: order_3.id, item_id: item_4.id, fulfilled: false)

review_1 = create(:review, user_id: corey.id, order_item_id: order_item_101.id)
review_2 = create(:review, user_id: corey.id, order_item_id: order_item_201.id)



admin = create(:admin)
user = create(:user)
merchant_1 = create(:merchant)

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

inactive_merchant_1 = create(:inactive_merchant)
inactive_user_1 = create(:inactive_user)

# item_101 = create(:item, user: merchant_1)
# item_102 create(:item, user: merchant_2)
# item_103 = create(:item, user: merchant_3)
# item_104 = create(:item, user: merchant_4)
# create_list(:item, 10, user: merchant_1)

inactive_item_1 = create(:inactive_item, user: merchant_1)
inactive_item_2 = create(:inactive_item, user: inactive_merchant_1)





# Random.new_seed
# rng = Random.new

# order = create(:completed_order, user: user)
# create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: (rng.rand(3)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: (rng.rand(5)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)

# # pending order
# order = create(:order, user: user)
# create(:order_item, order: order, item: item_1, price: 1, quantity: 1)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).days.ago, updated_at: rng.rand(23).hours.ago)

# order = create(:cancelled_order, user: user)
# create(:order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)
# create(:order_item, order: order, item: item_3, price: 3, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)

# order = create(:completed_order, user: user)
# create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1, created_at: (rng.rand(4)+1).days.ago, updated_at: rng.rand(59).minutes.ago)
# create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1, created_at: (rng.rand(23)+1).hour.ago, updated_at: rng.rand(59).minutes.ago)





puts 'seed data finished'
puts "Users created: #{User.count.to_i}"
# puts "Orders created: #{Order.count.to_i}"
puts "Items created: #{Item.count.to_i}"
# puts "OrderItems created: #{OrderItem.count.to_i}"
