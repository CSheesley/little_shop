require 'rails_helper'

RSpec.describe 'Average Item Rating', type: :feature do
  before :each do
    @user = create(:user)
    @item_1 = create(:item)
    @item_2 = create(:item)
    @item_3 = create(:item)

    @order_1 = create(:shipped_order, user_id: @user.id)
    @order_item_101 = create(:order_item, order_id: @order_1.id, item_id: @item_1.id, fulfilled: true)
    @order_item_102 = create(:order_item, order_id: @order_1.id, item_id: @item_2.id, fulfilled: true)

    @order_2 = create(:shipped_order, user_id: @user.id)
    @order_item_201 = create(:order_item, order_id: @order_2.id, item_id: @item_1.id, fulfilled: true)
    @order_item_202 = create(:order_item, order_id: @order_2.id, item_id: @item_2.id, fulfilled: true)
    @order_item_203 = create(:order_item, order_id: @order_2.id, item_id: @item_3.id, fulfilled: true)

    @review_101 = create(:review, user_id: @user.id, order_item_id: @order_item_101.id, rating: 5)
    @review_201 = create(:review, user_id: @user.id, order_item_id: @order_item_201.id, rating: 3)

    @review_102 = create(:review, user_id: @user.id, order_item_id: @order_item_102.id, rating: 1)
    @review_202 = create(:review, user_id: @user.id, order_item_id: @order_item_202.id, rating: 4)
  end

  context 'when visiting the items catalogue' do
    it 'shows the average rating for each item which has been reviewed' do

      visit items_path

      within "#item-#{@item_1.id}" do
        expect(page).to have_content("Average Rating: #{@item_1.average_rating}")
      end

      within "#item-#{@item_2.id}" do
        expect(page).to have_content("Average Rating: #{@item_2.average_rating}")
      end
    end

    it 'does not show a rating for an item which has not yet been reviewed' do

      visit items_path

      within "#item-#{@item_3.id}" do
        expect(page).to have_content("No Reviews Yet")
      end
    end
  end

  context 'when visiting an item show page' do
    it 'shows the average rating, and number of ratings for that item' do
      visit item_path(@item_1)
      expect(@item_1.number_of_reviews).to eq(2)

      within "#item" do
        expect(page).to have_content("Average Rating: #{@item_1.average_rating}")
        expect(page).to have_content("Number of Reviews: #{@item_1.number_of_reviews}")
      end

      visit item_path(@item_2)
      expect(@item_2.number_of_reviews).to eq(2)

      within "#item" do
        expect(page).to have_content("Average Rating: #{@item_2.average_rating}")
        expect(page).to have_content("Number of Reviews: #{@item_2.number_of_reviews}")
      end
    end

    it 'does not show a rating for an item which has not yet been reviewed' do
      visit item_path(@item_3)
      expect(@item_3.number_of_reviews).to eq(0)

      within "#item" do
        expect(page).to have_content("No Reviews Yet")
      end
    end
  end
end
