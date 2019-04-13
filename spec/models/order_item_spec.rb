require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe 'validations' do
    it { should validate_presence_of :price }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of :quantity }
    it { should validate_numericality_of(:quantity).only_integer }
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(1) }
  end

  describe 'relationships' do
    it { should belong_to :order }
    it { should belong_to :item }
    it { should have_one :review }
  end

  describe 'instance methods' do
    it '.subtotal' do
      oi = create(:order_item, quantity: 5, price: 3)

      expect(oi.subtotal).to eq(15)
    end

    it '.fulfill' do
      item = create(:item, inventory:2)
      oi1 = create(:order_item, quantity: 1, item: item)
      oi2 = create(:order_item, quantity: 1, item: item)
      oi3 = create(:order_item, quantity: 1, item: item)

      oi1.fulfill

      expect(oi1.fulfilled).to eq(true)
      expect(item.inventory).to eq(1)

      oi2.fulfill

      expect(oi1.fulfilled).to eq(true)
      expect(item.inventory).to eq(0)

      oi2.fulfill

      expect(oi2.fulfilled).to eq(true)
      expect(item.inventory).to eq(0)

      oi3.fulfill

      expect(oi2.fulfilled).to eq(true)
      expect(item.inventory).to eq(0)
    end

    it 'inventory_available' do
      item = create(:item, inventory:2)
      oi1 = create(:order_item, quantity: 1, item: item)
      oi2 = create(:order_item, quantity: 2, item: item)
      oi3 = create(:order_item, quantity: 3, item: item)

      expect(oi1.inventory_available).to eq(true)
      expect(oi2.inventory_available).to eq(true)
      expect(oi3.inventory_available).to eq(false)
    end

    context '#reviewable?' do
      it 'returns a boolean determining if the order_item is reviewable' do

        @user = create(:user)
        @item_1 = create(:item)
        @item_2 = create(:item)
        @item_3 = create(:item)
        @item_4 = create(:item)

        @order_1 = create(:shipped_order, user_id: @user.id)
        @order_item_101 = create(:order_item, order_id: @order_1.id, item_id: @item_1.id, fulfilled: true)
        @order_item_102 = create(:order_item, order_id: @order_1.id, item_id: @item_2.id, fulfilled: true)

        @order_2 = create(:shipped_order, user_id: @user.id)
        @order_item_201 = create(:order_item, order_id: @order_2.id, item_id: @item_2.id, fulfilled: true)
        @order_item_202 = create(:order_item, order_id: @order_2.id, item_id: @item_3.id, fulfilled: true)

        @order_3 = create(:order, user_id: @user.id)
        @order_item_301 = create(:order_item, order_id: @order_3.id, item_id: @item_3.id, fulfilled: true)
        @order_item_302 = create(:order_item, order_id: @order_3.id, item_id: @item_4.id, fulfilled: false)

        @review_202 = create(:review, user_id: @user.id, order_item_id: @order_item_202.id)

        expect(@order_item_101.reviewable?).to eq(true)
        expect(@order_item_102.reviewable?).to eq(true)

        expect(@order_item_201.reviewable?).to eq(true)
        expect(@order_item_202.reviewable?).to eq(false) # already reviewed

        expect(@order_item_301.reviewable?).to eq(false) # order not shipped
        expect(@order_item_302.reviewable?).to eq(false) # order not shipped
      end
    end
  end
end
