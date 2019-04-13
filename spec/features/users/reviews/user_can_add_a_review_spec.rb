require 'rails_helper'

RSpec.describe 'New Item Review', type: :feature do
  before :each do
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
  end

  describe 'As a user an order show page' do
    it 'has a review link for each order_item in a completed order' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_order_path(@order_1)

      expect(@order_1.order_items).to eq([@order_item_101, @order_item_102])
      expect(@order_1.status).to eq("shipped")

      within "#oitem-#{@order_item_101.id}" do
        expect(page).to have_link("Review")
      end

      within "#oitem-#{@order_item_102.id}" do
        expect(page).to have_link("Review")
      end
    end

    it 'does not show a review link for any order_item which has already been reviewed in the order' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_order_path(@order_2)

      expect(@order_2.order_items).to eq([@order_item_201, @order_item_202])
      expect(@order_2.status).to eq("shipped")

      within "#oitem-#{@order_item_201.id}" do
        expect(page).to have_link("Review")
      end

      within "#oitem-#{@order_item_202.id}" do
        expect(page).to_not have_link("Review")
      end
    end

    it 'does not show a review link for any order_item in an order that has not been shipped' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_order_path(@order_3)

      expect(@order_3.order_items).to eq([@order_item_301, @order_item_302])
      expect(@order_3.status).to eq("pending")

      within "#oitem-#{@order_item_301.id}" do
        expect(page).to_not have_link("Review")
      end

      within "#oitem-#{@order_item_302.id}" do
        expect(page).to_not have_link("Review")
      end
    end
  end
end
