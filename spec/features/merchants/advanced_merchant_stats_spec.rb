require 'rails_helper'

RSpec.describe 'Advanced Merchant Statistics', type: :feature do
  before :each do
    # four users (two states, 4 cities)
    # two states, two cities (limited data set)
    # this month, last month (limited data sets)

    # 12 merchants
    # 12 items
    # 24 orders (this month)
    # 24 orders (last month)
    # 24 order_items (this month)
    # 24 order_items (last month)
    # add additional cancelled orders

    #users
    @corey = create(:user, name: "Corey", city: "Golden", state:"CO")
    @chels = create(:user, name: "Chelsea", city: "Lakewood", state:"CO")
    @zach = create(:user, name: "Zach", city: "Chicago", state:"IL")
    @steph = create(:user, name: "Steph", city: "Wicker Park", state:"IL")

    #merchants
    @merch_1, @merch_2, @merch_3, @merch_4, @merch_5, @merch_6, @merch_7,
    @merch_8, @merch_9, @merch_10, @merch_11, @merch_12 = create_list(:merchant, 12)

    #items
    @item_1 = create(:item, user: @merch_1)
    @item_2 = create(:item, user: @merch_2)
    @item_3 = create(:item, user: @merch_3)
    @item_4 = create(:item, user: @merch_4)
    @item_5 = create(:item, user: @merch_5)
    @item_6 = create(:item, user: @merch_6)
    @item_7 = create(:item, user: @merch_7)
    @item_8 = create(:item, user: @merch_8)
    @item_9 = create(:item, user: @merch_9)
    @item_11 = create(:item, user: @merch_11)
    @item_12 = create(:item, user: @merch_12)

#This Month
    #orders
    @order_101 = @corey.orders.create(status: 'shipped', created_at: 10.days.ago, updated_at: 2.days.ago)
    @order_102 = @corey.orders.create(status: 'shipped', created_at: 8.days.ago, updated_at: 2.days.ago)
    @order_103 = @corey.orders.create(status: 'cancelled', created_at: 5.days.ago, updated_at: 3.days.ago)

    @order_201 = @chels.orders.create(status: 'shipped', created_at: 15.days.ago, updated_at: 8.days.ago)
    @order_202 = @chels.orders.create(status: 'shipped', created_at: 20.days.ago, updated_at: 10.days.ago)

    @order_301 = @zach.orders.create(status: 'shipped', created_at: 5.days.ago, updated_at: 3.days.ago)
    @order_302 = @zach.orders.create(status: 'shipped', created_at: 6.days.ago, updated_at: 3.days.ago)
    @order_303 = @zach.orders.create(status: 'cancelled', created_at: 7.days.ago, updated_at: 5.days.ago)

    @order_401 = @steph.orders.create(status: 'shipped', created_at: 12.days.ago, updated_at: 5.days.ago)
    @order_402 = @steph.orders.create(status: 'shipped', created_at: 20.days.ago, updated_at: 10.days.ago)


    #order_items (Corey - CO - Golden)
    @oi_cur_101_1 = create(:order_item, order_id: @order_101.id, item_id: @item_1.id, quantity: 100, fulfilled: true, created_at: @order_101.created_at, updated_at: 6.days.ago)
    @oi_cur_101_2 = create(:order_item, order_id: @order_101.id, item_id: @item_2.id, quantity: 200, fulfilled: true, created_at: @order_101.created_at, updated_at: 5.days.ago)
    @oi_cur_101_3 = create(:order_item, order_id: @order_101.id, item_id: @item_3.id, quantity: 300, fulfilled: true, created_at: @order_101.created_at, updated_at: 4.days.ago)

    @oi_cur_102_1 = create(:order_item, order_id: @order_102.id, item_id: @item_4.id, quantity: 400, fulfilled: true, created_at: @order_102.created_at, updated_at: 6.days.ago)
    @oi_cur_102_2 = create(:order_item, order_id: @order_102.id, item_id: @item_5.id, quantity: 500, fulfilled: true, created_at: @order_102.created_at, updated_at: 3.days.ago)
    @oi_cur_102_3 = create(:order_item, order_id: @order_102.id, item_id: @item_6.id, quantity: 600, fulfilled: true, created_at: @order_102.created_at, updated_at: 5.days.ago)

    #order_items (Chels - CO - Lakewood)
    @oi_cur_201_1 = create(:order_item, order_id: @order_201.id, item_id: @item_1.id, quantity: 100, fulfilled: true, created_at: @order_201.created_at, updated_at: 10.days.ago)
    @oi_cur_201_2 = create(:order_item, order_id: @order_201.id, item_id: @item_2.id, quantity: 200, fulfilled: true, created_at: @order_201.created_at, updated_at: 8.days.ago)
    @oi_cur_201_3 = create(:order_item, order_id: @order_201.id, item_id: @item_3.id, quantity: 300, fulfilled: true, created_at: @order_201.created_at, updated_at: 12.days.ago)

    @oi_cur_202_1 = create(:order_item, order_id: @order_202.id, item_id: @item_4.id, quantity: 400, fulfilled: true, created_at: @order_202.created_at, updated_at: 15.days.ago)
    @oi_cur_202_2 = create(:order_item, order_id: @order_202.id, item_id: @item_5.id, quantity: 500, fulfilled: true, created_at: @order_202.created_at, updated_at: 18.days.ago)
    @oi_cur_202_3 = create(:order_item, order_id: @order_202.id, item_id: @item_6.id, quantity: 600, fulfilled: true, created_at: @order_202.created_at, updated_at: 10.days.ago)

    #order_items (Zach - IL - Chicago)
    @oi_cur_301_1 = create(:order_item, order_id: @order_301.id, item_id: @item_7.id, quantity: 100, fulfilled: true, created_at: @order_301.created_at, updated_at: 2.days.ago)
    @oi_cur_301_2 = create(:order_item, order_id: @order_301.id, item_id: @item_8.id, quantity: 200, fulfilled: true, created_at: @order_301.created_at, updated_at: 3.days.ago)
    @oi_cur_301_3 = create(:order_item, order_id: @order_301.id, item_id: @item_9.id, quantity: 300, fulfilled: true, created_at: @order_301.created_at, updated_at: 4.days.ago)

    @oi_cur_302_1 = create(:order_item, order_id: @order_302.id, item_id: @item_10.id, quantity: 400, fulfilled: true, created_at: @order_302.created_at, updated_at: 3.days.ago)
    @oi_cur_302_2 = create(:order_item, order_id: @order_302.id, item_id: @item_11.id, quantity: 500, fulfilled: true, created_at: @order_302.created_at, updated_at: 4.days.ago)
    @oi_cur_302_3 = create(:order_item, order_id: @order_302.id, item_id: @item_12.id, quantity: 600, fulfilled: true, created_at: @order_302.created_at, updated_at: 5.days.ago)

    #order_items (Steph - IL - Wicker Park)
    @oi_cur_401_1 = create(:order_item, order_id: @order_401.id, item_id: @item_7.id, quantity: 100, fulfilled: true, created_at: @order_401.created_at, updated_at: 5.days.ago)
    @oi_cur_401_2 = create(:order_item, order_id: @order_401.id, item_id: @item_8.id, quantity: 200, fulfilled: true, created_at: @order_401.created_at, updated_at: 6.days.ago)
    @oi_cur_401_3 = create(:order_item, order_id: @order_401.id, item_id: @item_9.id, quantity: 300, fulfilled: true, created_at: @order_401.created_at, updated_at: 7.days.ago)

    @oi_cur_402_1 = create(:order_item, order_id: @order_402.id, item_id: @item_10.id, quantity: 400, fulfilled: true, created_at: @order_402.created_at, updated_at: 10.days.ago)
    @oi_cur_402_2 = create(:order_item, order_id: @order_402.id, item_id: @item_11.id, quantity: 500, fulfilled: true, created_at: @order_402.created_at, updated_at: 12.days.ago)
    @oi_cur_402_3 = create(:order_item, order_id: @order_402.id, item_id: @item_12.id, quantity: 600, fulfilled: true, created_at: @order_402.created_at, updated_at: 16.days.ago)


    #cancelled (order_103)
    @oi_cur_103_1 = create(:order_item, order_id: @order_103.id, item_id: @item_1.id, quantity: 100, fulfilled: false, created_at: @order_103.created_at, updated_at: 3.days.ago)
    @oi_cur_103_2 = create(:order_item, order_id: @order_103.id, item_id: @item_2.id, quantity: 200, fulfilled: false, created_at: @order_103.created_at, updated_at: 3.days.ago)
    @oi_cur_103_3 = create(:order_item, order_id: @order_103.id, item_id: @item_3.id, quantity: 300, fulfilled: false, created_at: @order_103.created_at, updated_at: 3.days.ago)

    #cancelled (order_303)
    @oi_cur_303_1 = create(:order_item, order_id: @order_303.id, item_id: @item_7.id, quantity: 100, fulfilled: false, created_at: @order_303.created_at, updated_at: 3.days.ago)
    @oi_cur_303_2 = create(:order_item, order_id: @order_303.id, item_id: @item_8.id, quantity: 200, fulfilled: false, created_at: @order_303.created_at, updated_at: 3.days.ago)
    @oi_cur_303_3 = create(:order_item, order_id: @order_303.id, item_id: @item_9.id, quantity: 300, fulfilled: false, created_at: @order_303.created_at, updated_at: 3.days.ago)











    # @oi_current_1_2
    #
    # @oi_current_2_1
    # @oi_current_2_2
    #
    # @oi_current_3_1
    # @oi_current_3_2
    #
    #
    # @order_item_21
    # @order_item_31

    # @order_2 = @user_2.orders.create!(status: 'shipped', created_at: 6.days.ago, updated_at: 1.day.ago)
    # @order_3 = @user_3.orders.create!(status: 'shipped', created_at: 4.days.ago, updated_at: 1.day.ago)
    # @order_4 = @user_4.orders.create!(status: 'shipped', created_at: 3.days.ago, updated_at: 1.day.ago)

    #orders(this month)

    #orders(last month)


    #order_items

#
# @beer_1 = Item.create!(name: "MGD", description: "good beer", stock: 120, item_price: 1.5, user_id: @merch_1.id )
# @beer_2 = Item.create!(name: "Mich Ultra", description: "better beer", stock: 150, item_price: 2.5, user_id: @merch_2.id )
# @beer_3 = Item.create!(name: "4 Noses", description: "yummy beer", stock: 180, item_price: 3.5, user_id: @merch_3.id )
# @beer_4 = Item.create!(name: "Guiness", description: "the best", stock: 180, item_price: 3.5, user_id: @merch_4.id )
#
# @order_1 = @user_1.orders.create!(status: 'shipped', created_at: 5.days.ago, updated_at: 1.day.ago)
# @order_2 = @user_2.orders.create!(status: 'shipped', created_at: 6.days.ago, updated_at: 1.day.ago)
# @order_3 = @user_3.orders.create!(status: 'shipped', created_at: 4.days.ago, updated_at: 1.day.ago)
# @order_4 = @user_4.orders.create!(status: 'shipped', created_at: 3.days.ago, updated_at: 1.day.ago)
# @order_5 = @user_5.orders.create!(status: 'shipped', created_at: 2.days.ago, updated_at: 1.day.ago)
# @order_6 = @user_1.orders.create!(status: 'shipped', created_at: 10.days.ago, updated_at: 1.day.ago)
#
# @oi_1 = OrderItem.create!(fulfilled: true, quantity: 3, order_price: 3, order_id: @order_1.id, item_id: @beer_1.id, created_at: 5.days.ago, updated_at: 1.day.ago)
# @oi_2 = OrderItem.create!(fulfilled: true, quantity: 6, order_price: 2, order_id: @order_1.id, item_id: @beer_2.id, created_at: 5.days.ago, updated_at: 1.day.ago)
# @oi_3 = OrderItem.create!(fulfilled: true, quantity: 9, order_price: 4, order_id: @order_2.id, item_id: @beer_3.id, created_at: 8.days.ago, updated_at: 1.day.ago)
# @oi_4 = OrderItem.create!(fulfilled: true, quantity: 11, order_price: 5, order_id: @order_2.id, item_id: @beer_4.id, created_at: 6.days.ago, updated_at: 1.day.ago)
# @oi_5 = OrderItem.create!(fulfilled: true, quantity: 4, order_price: 4, order_id: @order_3.id, item_id: @beer_1.id, created_at: 4.days.ago, updated_at: 1.day.ago)
# @oi_6 = OrderItem.create!(fulfilled: true, quantity: 10, order_price: 8, order_id: @order_4.id, item_id: @beer_2.id, created_at: 3.days.ago, updated_at: 1.day.ago)
# @oi_7 = OrderItem.create!(fulfilled: true, quantity: 25, order_price: 10, order_id: @order_5.id, item_id: @beer_3.id, created_at: 2.days.ago, updated_at: 1.day.ago)
# @oi_8 = OrderItem.create!(fulfilled: true, quantity: 1, order_price: 4, order_id: @order_6.id, item_id: @beer_4.id, created_at: 10.days.ago, updated_at: 1.day.ago)
#



    visit merchants_path
  end

  describe 'when I visit the merchants index page' do
    it 'has a leaderboard statistics area' do
      binding.pry
      expect(page).to have_content("Leaderboard Statistics")
      expect(page).to have_selector('section', id: "leaderboard")
    end

    context 'it shows the top ten merchants who...' do
      it 'have sold the most items this month' do
        # sold = any order that has been placed? Exclude cancelled?

      end

      it 'have sold the most items last month' do

      end

      it 'have fulfilled non-cancelled orders this month' do #non-cancelled order_items

      end

      it 'have fulfilled non-cancelled orders last month' do #non-cancelled order_items

      end
    end
  end

  describe 'as a logged in user - when I visit the merchants index page' do
    context 'additional stats are shown for top five merchants' do
      it 'who have fulfilled items fastest to my state' do

      end

      it 'who have fulfilled items fastest to my city' do

      end
    end
  end
end
