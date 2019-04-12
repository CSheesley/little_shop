require 'rails_helper'

RSpec.describe 'Profiles Reviews Index Page', type: :feature do
  before :each do
    @user = create(:user)

    @item_1 = create(:item)
    @item_2 = create(:item)

    @order_1 = create(:order)
    @order_2 = create(:order)

    @order_item_1 = create(:order_item, order_id: @order_1.id, item_id: @item_1.id)
    @order_item_2 = create(:order_item, order_id: @order_2.id, item_id: @item_2.id)

    @review_1 = create(:review, user_id: @user.id, order_item_id: @order_item_1.id)
    @review_2 = create(:review, user_id: @user.id, order_item_id: @order_item_2.id)

    login_as(@user)
    visit profile_reviews_path
  end

  context 'when I visit my reviews index page' do
    it 'shows a list of all of the reviews which I have written' do
      binding.pry
      within "#my-reviews-#{@review_1.id}" do
        expect(page).to have_content("Title: #{@review_1.title}")
        expect(page).to have_content("Rating: #{@review_1.rating}")
        expect(page).to have_content("Description: #{@review_1.description}")
        expect(page).to have_content("Created/Updated: #{@review_1.updated_at.strftime("%m/%d/%y")}")
      end

      within "#my-reviews-#{@review_2.id}" do
        expect(page).to have_content("Title: #{@review_2.title}")
        expect(page).to have_content("Rating: #{@review_2.rating}")
        expect(page).to have_content("Description: #{@review_2.description}")
        expect(page).to have_content("Created/Updated: #{@review_2.updated_at.strftime("%m/%d/%y")}")
      end
    end

    it 'gives me an option to edit or delete any of my reviews' do

      within "#my-reviews-#{@review_1.id}" do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end

      within "#my-reviews-#{@review_2.id}" do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end
    end

    it 'does not give me the ability to add a new review anywhere on this page' do

      expect(page).to_not have_content("Add New Review")
      expect(page).to_not have_content("New Review")
    end

    context 'when I click on the Edit button next to a review' do
      it 'I see a pre-populated form - after I click submit, I receive a notification and see the changes on my reviews page' do

        within "#my-reviews-#{@review_1.id}" do
          click_on "Edit"
          expect(current_path).to eq(edit_profile_review_path(@review_1))
        end

        expect(find_field("Title").value).to eq("#{@review_1.title}")
        expect(find_field("Rating").value).to eq("#{@review_1.rating}")
        expect(find_field("Description").value).to eq("#{@review_1.description}")

        fill_in "Title", with: "Item Broke"
        fill_in "Rating", with: 1
        fill_in "Description", with: "I changed my mind, this item broke"

        click_on "Update Review"

        @review_1.reload

        expect(current_path).to eq(profile_reviews_path)
        expect(page).to have_content("Review for #{@review_1.title} has been updated!")

        within "#my-reviews-#{@review_1.id}" do
          expect(page).to have_content("Title: Item Broke")
          expect(page).to have_content("Rating: 1")
          expect(page).to have_content("Description: I changed my mind, this item broke")
        end
      end
    end

    context 'when I click on the Delete button next to a review' do
      it 'I am notified that the review has been deleted, and I no longer see this review on my reviews page' do

        expect(@user.reviews).to eq([@review_1, @review_2])

        within "#my-reviews-#{@review_1.id}" do
          click_on "Delete"
        end

        expect(current_path).to eq(profile_reviews_path)
        expect(page).to have_content("Review for #{@review_1.title} has been deleted!")
        expect(page).to_not have_selector('div', id: "my-reviews-#{@review_1.id}")

        @user.reviews.reload

        expect(@user.reviews).to eq([@review_2])
      end
    end
  end
end
