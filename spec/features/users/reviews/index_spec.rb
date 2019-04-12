require 'rails_helper'

RSpec.describe 'Profiles Reviews Index Page', type: :feature do
  before :each do
    @user = create(:user)

    @item_1 = create(:item)
    @item_2 = create(:item)

    @review_1 = create(:review, user_id: @user.id)
    @review_2 = create(:review, user_id: @user.id)

    login_as(@user)
    visit profile_reviews_path
  end

  context 'when I visit my reviews index page' do
    it 'shows a list of all of the reviews which I have written' do

      within "#my-reviews-#{@review_1.id}" do
        expect(page).to have_content("Title: #{@review_1.title}")
        expect(page).to have_content("Description: #{@review_1.description}")
        expect(page).to have_content("Created/Updated: #{@review_1.updated_at.strftime("%m/%d/%y")}")
      end

      within "#my-reviews-#{@review_2.id}" do
        expect(page).to have_content("Title: #{@review_2.title}")
        expect(page).to have_content("Description: #{@review_2.description}")
        expect(page).to have_content("Created/Updated: #{@review_2.updated_at.strftime("%m/%d/%y")}")
      end
    end

    xit 'gives me an option to edit or delete any of my reviews' do

      within "#my-reviews-#{@review_1.id}" do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end

      within "#my-reviews-#{@review_2.id}" do
        expect(page).to have_link("Edit")
        expect(page).to have_link("Delete")
      end
    end

    xit 'does not give me the ability to add a new review anywhere on this page' do

      expect(page).to_not have_content("Add New Review")
      expect(page).to_not have_content("New Review")
    end

    context 'when I click on the Edit button next to a review' do
      xit 'I see a pre-populated form - after I click submit, I receive a notification and see the changes on my reviews page' do

      end
    end

    context 'when I click on the Delete button next to a review' do
      xit 'I am notified that the review has been deleted, and I no longer see this review on my reviews page' do

      end
    end
  end
end
