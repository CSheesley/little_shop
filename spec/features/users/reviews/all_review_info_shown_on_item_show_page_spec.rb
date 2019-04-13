require 'rails_helper'

RSpec.describe 'Item Show Page - Includes All Reviews and Info', type: :feature do
  before :each do
    @user = create(:user)
    @item_1 = create(:item)

    @order_1 = create(:shipped_order, user_id: @user.id)
    @order_item_1 = create(:order_item, order_id: @order_1.id, item_id: @item_1.id, fulfilled: true)

    @order_2 = create(:shipped_order, user_id: @user.id)
    @order_item_2 = create(:order_item, order_id: @order_2.id, item_id: @item_1.id, fulfilled: true)

    @review_1 = create(:review, user_id: @user.id, order_item_id: @order_item_1.id, rating: 5)
    @review_2 = create(:review, user_id: @user.id, order_item_id: @order_item_2.id, rating: 3, created_at: 3.days.ago, updated_at: 1.days.ago)

    visit item_path(@item_1)
  end

  context 'when visiting the items show page' do
    it 'shows me all reviews for that item, their info, and if the item has been updated' do
    
      within "#review-#{@review_1.id}" do
        expect(page).to have_content("Review Title: #{@review_1.title}")
        expect(page).to have_content("Rating: #{@review_1.rating}")
        expect(page).to have_content("Description: #{@review_1.description}")
        expect(page).to have_content("Created: #{@review_1.created_at.strftime('%B %e, %Y')}")
      end

      within "#review-#{@review_2.id}" do
        expect(page).to have_content("Review Title: #{@review_2.title}")
        expect(page).to have_content("Rating: #{@review_2.rating}")
        expect(page).to have_content("Description: #{@review_2.description}")
        expect(page).to have_content("Created: #{@review_2.created_at.strftime('%B %e, %Y')}")
        expect(page).to have_content("Updated: #{@review_2.updated_at.strftime('%B %e, %Y')}")
      end
    end
  end
end
