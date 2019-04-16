require 'rails_helper'

RSpec.describe 'Advanced Merchant Statistics', type: :feature do
  before :each do
    # four users (two states, 4 cities)
    # two states, two cities (limited data set)
    # this month, last month (limited data sets)

    # 12 merchants
    # 12 items

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
    @item_10 = create(:item, user: @merch_10)
    @item_11 = create(:item, user: @merch_11)
    @item_12 = create(:item, user: @merch_12)

#Current Month (today-30 days)
    #orders
    @order_101 = @corey.orders.create(status: 'shipped', created_at: 30.days.ago, updated_at: 2.days.ago)
    @order_102 = @corey.orders.create(status: 'shipped', created_at: 8.days.ago, updated_at: 2.days.ago)
    @order_103 = @corey.orders.create(status: 'cancelled', created_at: 5.days.ago, updated_at: 3.days.ago)
    @order_104 = @corey.orders.create(status: 'shipped', created_at: 15.days.ago, updated_at: 10.days.ago)

    @order_201 = @chels.orders.create(status: 'shipped', created_at: 15.days.ago, updated_at: 8.days.ago)
    @order_202 = @chels.orders.create(status: 'shipped', created_at: 20.days.ago, updated_at: 10.days.ago)
    @order_203 = @chels.orders.create(status: 'shipped', created_at: 6.days.ago, updated_at: 2.days.ago)

    @order_301 = @zach.orders.create(status: 'shipped', created_at: 5.days.ago, updated_at: 3.days.ago)
    @order_302 = @zach.orders.create(status: 'shipped', created_at: 6.days.ago, updated_at: 3.days.ago)
    @order_303 = @zach.orders.create(status: 'cancelled', created_at: 7.days.ago, updated_at: 5.days.ago)
    @order_304 = @zach.orders.create(status: 'shipped', created_at: 12.days.ago, updated_at: 7.days.ago)

    @order_401 = @steph.orders.create(status: 'shipped', created_at: 12.days.ago, updated_at: 5.days.ago)
    @order_402 = @steph.orders.create(status: 'shipped', created_at: 20.days.ago, updated_at: 10.days.ago)
    @order_403 = @steph.orders.create(status: 'shipped', created_at: 5.days.ago, updated_at: 2.days.ago)

    #order_items (Corey - CO - Golden)
    @oi_cur_101_1 = create(:order_item, order_id: @order_101.id, item_id: @item_1.id, quantity: 100, fulfilled: true, created_at: @order_101.created_at, updated_at: 6.days.ago)
    @oi_cur_101_2 = create(:order_item, order_id: @order_101.id, item_id: @item_2.id, quantity: 200, fulfilled: true, created_at: @order_101.created_at, updated_at: 5.days.ago)
    @oi_cur_101_3 = create(:order_item, order_id: @order_101.id, item_id: @item_3.id, quantity: 300, fulfilled: true, created_at: @order_101.created_at, updated_at: 4.days.ago)

    @oi_cur_102_1 = create(:order_item, order_id: @order_102.id, item_id: @item_4.id, quantity: 400, fulfilled: true, created_at: @order_102.created_at, updated_at: 6.days.ago)
    @oi_cur_102_2 = create(:order_item, order_id: @order_102.id, item_id: @item_5.id, quantity: 500, fulfilled: true, created_at: @order_102.created_at, updated_at: 3.days.ago)
    @oi_cur_102_3 = create(:order_item, order_id: @order_102.id, item_id: @item_6.id, quantity: 600, fulfilled: true, created_at: @order_102.created_at, updated_at: 5.days.ago)

    @oi_cur_104_1 = create(:order_item, order_id: @order_104.id, item_id: @item_4.id, quantity: 440, fulfilled: true, created_at: @order_104.created_at, updated_at: 10.days.ago)
    @oi_cur_104_2 = create(:order_item, order_id: @order_104.id, item_id: @item_5.id, quantity: 540, fulfilled: true, created_at: @order_104.created_at, updated_at: 12.days.ago)
    @oi_cur_104_3 = create(:order_item, order_id: @order_104.id, item_id: @item_6.id, quantity: 640, fulfilled: true, created_at: @order_104.created_at, updated_at: 13.days.ago)

    #order_items (Chels - CO - Lakewood)
    @oi_cur_201_1 = create(:order_item, order_id: @order_201.id, item_id: @item_1.id, quantity: 100, fulfilled: true, created_at: @order_201.created_at, updated_at: 10.days.ago)
    @oi_cur_201_2 = create(:order_item, order_id: @order_201.id, item_id: @item_2.id, quantity: 200, fulfilled: true, created_at: @order_201.created_at, updated_at: 8.days.ago)
    @oi_cur_201_3 = create(:order_item, order_id: @order_201.id, item_id: @item_3.id, quantity: 300, fulfilled: true, created_at: @order_201.created_at, updated_at: 12.days.ago)

    @oi_cur_202_1 = create(:order_item, order_id: @order_202.id, item_id: @item_4.id, quantity: 400, fulfilled: true, created_at: @order_202.created_at, updated_at: 15.days.ago)
    @oi_cur_202_2 = create(:order_item, order_id: @order_202.id, item_id: @item_5.id, quantity: 500, fulfilled: true, created_at: @order_202.created_at, updated_at: 18.days.ago)
    @oi_cur_202_3 = create(:order_item, order_id: @order_202.id, item_id: @item_6.id, quantity: 600, fulfilled: true, created_at: @order_202.created_at, updated_at: 10.days.ago)

    @oi_cur_203_1 = create(:order_item, order_id: @order_203.id, item_id: @item_4.id, quantity: 400, fulfilled: true, created_at: @order_203.created_at, updated_at: 2.days.ago)
    @oi_cur_203_2 = create(:order_item, order_id: @order_203.id, item_id: @item_5.id, quantity: 500, fulfilled: true, created_at: @order_203.created_at, updated_at: 3.days.ago)
    @oi_cur_203_3 = create(:order_item, order_id: @order_203.id, item_id: @item_6.id, quantity: 600, fulfilled: true, created_at: @order_203.created_at, updated_at: 4.days.ago)

    #order_items (Zach - IL - Chicago)
    @oi_cur_301_1 = create(:order_item, order_id: @order_301.id, item_id: @item_7.id, quantity: 700, fulfilled: true, created_at: @order_301.created_at, updated_at: 1.days.ago)
    @oi_cur_301_2 = create(:order_item, order_id: @order_301.id, item_id: @item_8.id, quantity: 250, fulfilled: true, created_at: @order_301.created_at, updated_at: 2.days.ago)
    @oi_cur_301_3 = create(:order_item, order_id: @order_301.id, item_id: @item_9.id, quantity: 400, fulfilled: true, created_at: @order_301.created_at, updated_at: 4.days.ago)

    @oi_cur_302_1 = create(:order_item, order_id: @order_302.id, item_id: @item_10.id, quantity: 450, fulfilled: true, created_at: @order_302.created_at, updated_at: 3.days.ago)
    @oi_cur_302_2 = create(:order_item, order_id: @order_302.id, item_id: @item_11.id, quantity: 1000, fulfilled: true, created_at: @order_302.created_at, updated_at: 4.days.ago)
    @oi_cur_302_3 = create(:order_item, order_id: @order_302.id, item_id: @item_12.id, quantity: 650, fulfilled: true, created_at: @order_302.created_at, updated_at: 5.days.ago)

    @oi_cur_304_1 = create(:order_item, order_id: @order_304.id, item_id: @item_3.id, quantity: 450, fulfilled: true, created_at: @order_304.created_at, updated_at: 8.days.ago)
    @oi_cur_304_2 = create(:order_item, order_id: @order_304.id, item_id: @item_4.id, quantity: 100, fulfilled: true, created_at: @order_304.created_at, updated_at: 7.days.ago)
    @oi_cur_304_3 = create(:order_item, order_id: @order_304.id, item_id: @item_5.id, quantity: 550, fulfilled: true, created_at: @order_304.created_at, updated_at: 9.days.ago)

    #order_items (Steph - IL - Wicker Park)
    @oi_cur_401_1 = create(:order_item, order_id: @order_401.id, item_id: @item_1.id, quantity: 150, fulfilled: true, created_at: @order_401.created_at, updated_at: 5.days.ago)
    @oi_cur_401_2 = create(:order_item, order_id: @order_401.id, item_id: @item_2.id, quantity: 250, fulfilled: true, created_at: @order_401.created_at, updated_at: 6.days.ago)
    @oi_cur_401_3 = create(:order_item, order_id: @order_401.id, item_id: @item_3.id, quantity: 350, fulfilled: true, created_at: @order_401.created_at, updated_at: 7.days.ago)

    @oi_cur_402_1 = create(:order_item, order_id: @order_402.id, item_id: @item_10.id, quantity: 450, fulfilled: true, created_at: @order_402.created_at, updated_at: 10.days.ago)
    @oi_cur_402_2 = create(:order_item, order_id: @order_402.id, item_id: @item_11.id, quantity: 1000, fulfilled: true, created_at: @order_402.created_at, updated_at: 12.days.ago)
    @oi_cur_402_3 = create(:order_item, order_id: @order_402.id, item_id: @item_12.id, quantity: 650, fulfilled: true, created_at: @order_402.created_at, updated_at: 16.days.ago)

    @oi_cur_403_1 = create(:order_item, order_id: @order_403.id, item_id: @item_5.id, quantity: 500, fulfilled: true, created_at: @order_403.created_at, updated_at: 5.days.ago)

    #cancelled (order_103)
    @oi_cur_103_1 = create(:order_item, order_id: @order_103.id, item_id: @item_1.id, quantity: 100, fulfilled: false, created_at: @order_103.created_at, updated_at: 3.days.ago)
    @oi_cur_103_2 = create(:order_item, order_id: @order_103.id, item_id: @item_2.id, quantity: 200, fulfilled: false, created_at: @order_103.created_at, updated_at: 3.days.ago)
    @oi_cur_103_3 = create(:order_item, order_id: @order_103.id, item_id: @item_3.id, quantity: 300, fulfilled: false, created_at: @order_103.created_at, updated_at: 3.days.ago)

    #cancelled (order_303)
    @oi_cur_303_1 = create(:order_item, order_id: @order_303.id, item_id: @item_7.id, quantity: 100, fulfilled: false, created_at: @order_303.created_at, updated_at: 3.days.ago)
    @oi_cur_303_2 = create(:order_item, order_id: @order_303.id, item_id: @item_8.id, quantity: 200, fulfilled: false, created_at: @order_303.created_at, updated_at: 3.days.ago)
    @oi_cur_303_3 = create(:order_item, order_id: @order_303.id, item_id: @item_9.id, quantity: 300, fulfilled: false, created_at: @order_303.created_at, updated_at: 3.days.ago)

############################################################################################################

    #Previous Month (30-60 days)
    @order_501 = @corey.orders.create(status: 'shipped', created_at: 40.days.ago, updated_at: 25.days.ago)
    @order_502 = @corey.orders.create(status: 'shipped', created_at: 38.days.ago, updated_at: 28.days.ago)
    @order_503 = @corey.orders.create(status: 'cancelled', created_at: 31.days.ago, updated_at: 26.days.ago)
    @order_504 = @corey.orders.create(status: 'shipped', created_at: 45.days.ago, updated_at: 32.days.ago)

    @order_601 = @chels.orders.create(status: 'shipped', created_at: 48.days.ago, updated_at: 38.days.ago)
    @order_602 = @chels.orders.create(status: 'shipped', created_at: 52.days.ago, updated_at: 46.days.ago)
    @order_603 = @chels.orders.create(status: 'shipped', created_at: 36.days.ago, updated_at: 30.days.ago)

    @order_701 = @zach.orders.create(status: 'shipped', created_at: 35.days.ago, updated_at: 26.days.ago)
    @order_702 = @zach.orders.create(status: 'shipped', created_at: 37.days.ago, updated_at: 30.days.ago)
    @order_703 = @zach.orders.create(status: 'cancelled', created_at: 50.days.ago, updated_at: 40.days.ago)
    @order_704 = @zach.orders.create(status: 'shipped', created_at: 42.days.ago, updated_at: 40.days.ago)

    @order_801 = @steph.orders.create(status: 'shipped', created_at: 43.days.ago, updated_at: 25.days.ago)
    @order_802 = @steph.orders.create(status: 'shipped', created_at: 55.days.ago, updated_at: 38.days.ago)
    @order_803 = @steph.orders.create(status: 'shipped', created_at: 60.days.ago, updated_at: 55.days.ago)

    #order_items (Corey - CO - Golden)
    @oi_prev_501_1 = create(:order_item, order_id: @order_501.id, item_id: @item_1.id, quantity: 100, fulfilled: true, created_at: @order_501.created_at, updated_at: 30.days.ago)
    @oi_prev_501_2 = create(:order_item, order_id: @order_501.id, item_id: @item_2.id, quantity: 200, fulfilled: true, created_at: @order_501.created_at, updated_at: 35.days.ago)
    @oi_prev_501_3 = create(:order_item, order_id: @order_501.id, item_id: @item_3.id, quantity: 300, fulfilled: true, created_at: @order_501.created_at, updated_at: 25.days.ago)

    @oi_prev_502_1 = create(:order_item, order_id: @order_502.id, item_id: @item_4.id, quantity: 400, fulfilled: true, created_at: @order_502.created_at, updated_at: 26.days.ago)
    @oi_prev_502_2 = create(:order_item, order_id: @order_502.id, item_id: @item_5.id, quantity: 300, fulfilled: true, created_at: @order_502.created_at, updated_at: 30.days.ago)
    @oi_prev_502_3 = create(:order_item, order_id: @order_502.id, item_id: @item_6.id, quantity: 600, fulfilled: true, created_at: @order_502.created_at, updated_at: 28.days.ago)

    @oi_prev_504_1 = create(:order_item, order_id: @order_504.id, item_id: @item_4.id, quantity: 200, fulfilled: true, created_at: @order_504.created_at, updated_at: 40.days.ago)
    @oi_prev_504_2 = create(:order_item, order_id: @order_504.id, item_id: @item_5.id, quantity: 540, fulfilled: true, created_at: @order_504.created_at, updated_at: 32.days.ago)
    @oi_prev_504_3 = create(:order_item, order_id: @order_504.id, item_id: @item_7.id, quantity: 640, fulfilled: true, created_at: @order_504.created_at, updated_at: 36.days.ago)

    #order_items (Chels - CO - Lakewood)
    @oi_prev_601_1 = create(:order_item, order_id: @order_601.id, item_id: @item_1.id, quantity: 100, fulfilled: true, created_at: @order_601.created_at, updated_at: 40.days.ago)
    @oi_prev_601_2 = create(:order_item, order_id: @order_601.id, item_id: @item_2.id, quantity: 200, fulfilled: true, created_at: @order_601.created_at, updated_at: 38.days.ago)
    @oi_prev_601_3 = create(:order_item, order_id: @order_601.id, item_id: @item_3.id, quantity: 300, fulfilled: true, created_at: @order_601.created_at, updated_at: 42.days.ago)

    @oi_prev_602_1 = create(:order_item, order_id: @order_602.id, item_id: @item_4.id, quantity: 400, fulfilled: true, created_at: @order_602.created_at, updated_at: 49.days.ago)
    @oi_prev_602_2 = create(:order_item, order_id: @order_602.id, item_id: @item_5.id, quantity: 200, fulfilled: true, created_at: @order_602.created_at, updated_at: 46.days.ago)
    @oi_prev_602_3 = create(:order_item, order_id: @order_602.id, item_id: @item_6.id, quantity: 600, fulfilled: true, created_at: @order_602.created_at, updated_at: 50.days.ago)

    @oi_prev_603_1 = create(:order_item, order_id: @order_603.id, item_id: @item_4.id, quantity: 400, fulfilled: true, created_at: @order_603.created_at, updated_at: 34.days.ago)
    @oi_prev_603_2 = create(:order_item, order_id: @order_603.id, item_id: @item_5.id, quantity: 500, fulfilled: true, created_at: @order_603.created_at, updated_at: 32.days.ago)
    @oi_prev_603_3 = create(:order_item, order_id: @order_603.id, item_id: @item_6.id, quantity: 600, fulfilled: true, created_at: @order_603.created_at, updated_at: 30.days.ago)

    #order_items (Zach - IL - Chicago)
    @oi_prev_701_1 = create(:order_item, order_id: @order_701.id, item_id: @item_7.id, quantity: 700, fulfilled: true, created_at: @order_701.created_at, updated_at: 30.days.ago)
    @oi_prev_701_2 = create(:order_item, order_id: @order_701.id, item_id: @item_8.id, quantity: 250, fulfilled: true, created_at: @order_701.created_at, updated_at: 26.days.ago)
    @oi_prev_701_3 = create(:order_item, order_id: @order_701.id, item_id: @item_9.id, quantity: 400, fulfilled: true, created_at: @order_701.created_at, updated_at: 29.days.ago)

    @oi_prev_702_1 = create(:order_item, order_id: @order_702.id, item_id: @item_2.id, quantity: 450, fulfilled: true, created_at: @order_702.created_at, updated_at: 35.days.ago)
    @oi_prev_702_2 = create(:order_item, order_id: @order_702.id, item_id: @item_11.id, quantity: 1000, fulfilled: true, created_at: @order_702.created_at, updated_at: 30.days.ago)
    @oi_prev_702_3 = create(:order_item, order_id: @order_702.id, item_id: @item_9.id, quantity: 650, fulfilled: true, created_at: @order_702.created_at, updated_at: 32.days.ago)

    @oi_prev_704_1 = create(:order_item, order_id: @order_704.id, item_id: @item_1.id, quantity: 450, fulfilled: true, created_at: @order_704.created_at, updated_at: 44.days.ago)
    @oi_prev_704_2 = create(:order_item, order_id: @order_704.id, item_id: @item_4.id, quantity: 100, fulfilled: true, created_at: @order_704.created_at, updated_at: 42.days.ago)
    @oi_prev_704_3 = create(:order_item, order_id: @order_704.id, item_id: @item_5.id, quantity: 350, fulfilled: true, created_at: @order_704.created_at, updated_at: 40.days.ago)

    #order_items (Steph - IL - Wicker Park)
    @oi_prev_801_1 = create(:order_item, order_id: @order_801.id, item_id: @item_1.id, quantity: 150, fulfilled: true, created_at: @order_801.created_at, updated_at: 25.days.ago)
    @oi_prev_801_2 = create(:order_item, order_id: @order_801.id, item_id: @item_2.id, quantity: 250, fulfilled: true, created_at: @order_801.created_at, updated_at: 35.days.ago)
    @oi_prev_801_3 = create(:order_item, order_id: @order_801.id, item_id: @item_3.id, quantity: 350, fulfilled: true, created_at: @order_801.created_at, updated_at: 40.days.ago)

    @oi_prev_802_1 = create(:order_item, order_id: @order_802.id, item_id: @item_10.id, quantity: 450, fulfilled: true, created_at: @order_802.created_at, updated_at: 44.days.ago)
    @oi_prev_802_2 = create(:order_item, order_id: @order_802.id, item_id: @item_8.id, quantity: 1000, fulfilled: true, created_at: @order_802.created_at, updated_at: 38.days.ago)
    @oi_prev_802_3 = create(:order_item, order_id: @order_802.id, item_id: @item_12.id, quantity: 500, fulfilled: true, created_at: @order_802.created_at, updated_at: 42.days.ago)

    @oi_prev_803_1 = create(:order_item, order_id: @order_803.id, item_id: @item_4.id, quantity: 500, fulfilled: true, created_at: @order_803.created_at, updated_at: 55.days.ago)

    #cancelled (order_503)
    @oi_cur_503_1 = create(:order_item, order_id: @order_503.id, item_id: @item_4.id, quantity: 100, fulfilled: false, created_at: @order_503.created_at, updated_at: 26.days.ago)
    @oi_cur_503_2 = create(:order_item, order_id: @order_503.id, item_id: @item_5.id, quantity: 200, fulfilled: false, created_at: @order_503.created_at, updated_at: 29.days.ago)
    @oi_cur_503_3 = create(:order_item, order_id: @order_503.id, item_id: @item_6.id, quantity: 300, fulfilled: false, created_at: @order_503.created_at, updated_at: 30.days.ago)

    #cancelled (order_703)
    @oi_cur_703_1 = create(:order_item, order_id: @order_703.id, item_id: @item_10.id, quantity: 100, fulfilled: false, created_at: @order_703.created_at, updated_at: 40.days.ago)
    @oi_cur_703_2 = create(:order_item, order_id: @order_703.id, item_id: @item_11.id, quantity: 200, fulfilled: false, created_at: @order_703.created_at, updated_at: 42.days.ago)
    @oi_cur_703_3 = create(:order_item, order_id: @order_703.id, item_id: @item_12.id, quantity: 300, fulfilled: false, created_at: @order_703.created_at, updated_at: 44.days.ago)

    visit merchants_path
  end

  describe 'when I visit the merchants index page' do
    it 'has a leaderboard statistics area' do

      expect(page).to have_content("Leaderboard Statistics")
      expect(page).to have_selector('section', id: "leaderboard")
    end

    context 'it shows the top ten merchants who...' do
      it 'have sold the most items this month' do

        within "#top-ten-merchants" do
          within "#by-items-sold-current-month" do
            expect(page.all('li')[0]).to have_content("#{@merch_5.name} - 3090")
            expect(page.all('li')[1]).to have_content("#{@merch_6.name} - 2440")
            expect(page.all('li')[2]).to have_content("#{@merch_11.name} - 2000")
            expect(page.all('li')[3]).to have_content("#{@merch_4.name} -  1740")
            expect(page.all('li')[4]).to have_content("#{@merch_3.name} - 1400")
            expect(page.all('li')[5]).to have_content("#{@merch_12.name} - 1300")
            expect(page.all('li')[6]).to have_content("#{@merch_10.name} - 900")
            expect(page.all('li')[7]).to have_content("#{@merch_7.name} -  700")
            expect(page.all('li')[8]).to have_content("#{@merch_2.name} - 650")
            expect(page.all('li')[9]).to have_content("#{@merch_9.name} -  400")

            expect(page.all('li')).to_not have_content("#{@merch_1.name}")
            expect(page.all('li')).to_not have_content("#{@merch_8.name}")

              # "Merchant Name 5 -  3090"
              # "Merchant Name 6 -  2440"
              # "Merchant Name 11 -  2000"
              # "Merchant Name 4 -  1740"
              # "Merchant Name 3 -  1400"
              # "Merchant Name 12 -  1300"
              # "Merchant Name 10 -  900"
              # "Merchant Name 7 -  700"
              # "Merchant Name 2 -  650"
              # "Merchant Name 9 -  400"
          end
        end
      end

      it 'have sold the most items last month' do

        within "#top-ten-merchants" do
          within "#by-items-sold-previous-month" do
            expect(page.all('li')[0]).to have_content("#{@merch_4.name} - 2000")
            expect(page.all('li')[1]).to have_content("#{@merch_5.name} - 1890")
            expect(page.all('li')[2]).to have_content("#{@merch_6.name} - 1800")
            expect(page.all('li')[3]).to have_content("#{@merch_7.name} - 1340")
            expect(page.all('li')[4]).to have_content("#{@merch_8.name} - 1250")
            expect(page.all('li')[5]).to have_content("#{@merch_2.name} - 1100")
            expect(page.all('li')[6]).to have_content("#{@merch_9.name} - 1050")
            expect(page.all('li')[7]).to have_content("#{@merch_11.name} - 1000")
            expect(page.all('li')[8]).to have_content("#{@merch_3.name} - 950")
            expect(page.all('li')[9]).to have_content("#{@merch_1.name} -  800")

            expect(page.all('li')).to_not have_content("#{@merch_12.name}")
            expect(page.all('li')).to_not have_content("#{@merch_10.name}")
          end
        end
      end

      it 'have fulfilled non-cancelled orders this month' do #non-cancelled order_items

        within "#top-ten-merchants" do
          within "#by-filled-orders-current-month" do
            expect(page.all('li')[0]).to have_content("#{@merch_5.name} - 6")
            expect(page.all('li')[1]).to have_content("#{@merch_4.name} - 5")
            expect(page.all('li')[2]).to have_content("#{@merch_6.name} - 4")
            expect(page.all('li')[3]).to have_content("#{@merch_3.name} - 4")
            expect(page.all('li')[4]).to have_content("#{@merch_2.name} - 3")
            expect(page.all('li')[5]).to have_content("#{@merch_1.name} - 3")
            expect(page.all('li')[6]).to have_content("#{@merch_11.name} - 2")
            expect(page.all('li')[7]).to have_content("#{@merch_12.name} - 2")
            expect(page.all('li')[8]).to have_content("#{@merch_10.name} - 2")
            expect(page.all('li')[9]).to have_content("#{@merch_7.name} -  1")

            expect(page.all('li')).to_not have_content("#{@merch_8.name}")
            expect(page.all('li')).to_not have_content("#{@merch_9.name}")
          end
        end
      end

      it 'have fulfilled non-cancelled orders last month' do #non-cancelled order_items

        within "#top-ten-merchants" do
          within "#by-filled-orders-previous-month" do
            expect(page.all('li')[0]).to have_content("#{@merch_4.name} - 6")
            expect(page.all('li')[1]).to have_content("#{@merch_5.name} - 5")
            expect(page.all('li')[2]).to have_content("#{@merch_2.name} - 4")
            expect(page.all('li')[3]).to have_content("#{@merch_1.name} - 4")
            expect(page.all('li')[4]).to have_content("#{@merch_6.name} - 3")
            expect(page.all('li')[5]).to have_content("#{@merch_3.name} - 3")
            expect(page.all('li')[6]).to have_content("#{@merch_7.name} - 2")
            expect(page.all('li')[7]).to have_content("#{@merch_8.name} - 2")
            expect(page.all('li')[8]).to have_content("#{@merch_9.name} - 2")
            expect(page.all('li')[9]).to have_content("#{@merch_11.name} -  1")

            expect(page.all('li')).to_not have_content("#{@merch_12.name}")
            expect(page.all('li')).to_not have_content("#{@merch_10.name}")
          end
        end
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
